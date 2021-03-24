---
title: "What Did the require Do in Node.js"
date: 2021-03-18T00:15:13+08:00
tags: ["nodejs"]
---

> **Warning**: 最新版本的 Node.js 已经更新了 `require` 的逻辑, 此文章的相关代码已过时, 但逻辑总体上不变;
>
> 或者直接看源码 [node/lib/internal/modules/cjs/](https://github.com/nodejs/node/tree/master/lib/internal/modules/cjs)

## Environment

Node Version: `v11.1.0`

## Prepare

We have two file in `/home/csyakamoz/Desktop/test` directory.

**index.js**

```javascript
require("./a");
```

**a.js**

```javascript
let i = 0;

module.exports = () => {
  console.log(++i);
};
```

## Start

### makeRequireFunction

**Notice**:

- `mod` is the module object of index.js

```javascript
function makeRequireFunction(mod) {
  const Module = mod.constructor;

  function require(path) {
    // 👉 start here, and path is "./a"
    try {
      exports.requireDepth += 1;
      return mod.require(path);
    } finally {
      exports.requireDepth -= 1;
    }
  }

  function resolve(request, options) {
    if (typeof request !== "string") {
      throw new ERR_INVALID_ARG_TYPE("request", "string", request);
    }
    return Module._resolveFilename(request, mod, false, options);
  }

  require.resolve = resolve;

  function paths(request) {
    if (typeof request !== "string") {
      throw new ERR_INVALID_ARG_TYPE("request", "string", request);
    }
    return Module._resolveLookupPaths(request, mod, true);
  }

  resolve.paths = paths;

  require.main = process.mainModule;

  // Enable support to add extra extension types.
  require.extensions = Module._extensions;

  // So require.cache point to Module._cache
  require.cache = Module._cache;

  return require;
}
```

### Module.prototype.require

**Notice**:

- `this` point to the module object of index.js
- `id` is './a'

```javascript
Module.prototype.require = function (id) {
    if (type id !== 'string') {
        throw new ERR_INVALID_ARG_TYPE('id', 'string', id);
    }

    if (id === '') {
        throw new ERR_INVALID_ARG_VALUE('id', id, 'must be a non-empty string');
    }

  return Module._load(id, this, /*isMain */ false);
}
```

### Module.\_load

**Notice**:

- `request` is "./a"
- `parent` is the module object of index.js
- `isMain` is false

```javascript
Module._load = function (request, parent, isMain) {
  // Get the absolute path of "./a"
  // In this case, filename is "/home/csyakamoz/Desktop/test/a.js"
  var filename = Module._resolveFilename(request, parent, isMain);

  // check cache
  // if cache exists, then update parent.children and return cache
  var cachedModule = Module._cache[filename];
  if (cachedModule) {
    updateChildren(parent, cachedModule, true);
    return cachedModule.exports;
  }

  // return native module if filename is a native module
  if (NativeModule.nonInternalExists(filename)) {
    debug("load native module %s", request);
    return NativeModule.require(filename);
  }

  // prepare a new module object for a.js
  var module = new Module(filename, parent);

  if (isMain) {
    // https://nodejs.org/api/process.html#process_process_mainmodule
    process.mainModule = module;
    // mainModule.id is "."
    module.id = ".";
  }

  Module._cache[filename] = module;

  tryModuleLoad(module, filename);

  // After tryModuleLoad(module, filename)
  // module.exports is a function exported in a.js
  return module.exports;
};
```

### tryModuleLoad

**Notice**:

- `module` is the module object of a.js
- `filename` is "/home/csyakamoz/Desktop/test/a.js"

```javascript
function tryModuleLoad(module, filename) {
  var threw = true;
  try {
    module.load(filename);
    threw = false;
  } finally {
    if (threw) {
      delete Module._cache[filename];
    }
  }
}
```

### Module.prototype.load

**Notice**:

- "this" point to the module object of a.js
- filename is "/home/csyakamoz/Desktop/test/a.js"

```javascript
Module.prototype.load = function (filename) {
  assert(!this.loaded);
  this.filename = filename;
  // https://nodejs.org/api/modules.html#modules_loading_from_node_modules_folders
  /*
   * this.paths = [
   *	 "/home/csyakamoz/Desktop/test/node_modules",
   *	 "/home/csyakamoz/Desktop/node_modules",
   *	 "/home/csyakamoz/node_modules",
   *	 "/home/node_modules",
   *	 "/node_modules"
   * ];
   */
  this.paths = Module._nodeModulePaths(path.dirname(filename));

  var extension = path.extname(filename) || ".js";
  // Object.keys(Module._extensions) is ['.js', '.json', '.node']
  if (!Module._extensions[extension]) extension = ".js";
  Module._extensions[extension](this, filename);
  this.loaded = true;
};
```

### Module.\_extensions['.js']

**Notice**:

- `module` is the module object of a.js
- `filename` is "/home/csyakamoz/Desktop/test/a.js"

```javascript
// Native extension for .js
Module._extensions[".js"] = function (module, filename) {
  /*
   * content: "let i = 0;module.exports = () => {    console.log(++i);};"
   */
  var content = fs.readFileSync(filename, "utf8");
  module._compile(stripBOM(content), filename);
};
```

### Module.prototype.\_compile

**Notice**:

- `content` is "let i = 0;module.exports = () => { console.log(++i);};"
- `filename` is "/home/csyakamoz/Desktop/test/a.js"
- `this` point to the module object of a.js

```js
Module.prototype._compile = function (content, filename) {
  content = stripShebang(content);
  /*
   * wrapper is string, and like this:
   * "(function (exports, require, module, __filename, __dirname) {
   *      let i = 0;
   *      module.exports = () => {
   *          console.log(++i);
   *      };
   *  });"
   */
  var wrapper = Module.wrap(content);

  // https://nodejs.org/api/vm.html#vm_vm_runinthiscontext_code_options
  // compiledWrapper is the Function  as shown above
  var compiledWrapper = vm.runInThisContext(wrapper, {
    filename: filename,
    lineOffset: 0,
    displayErrors: true,
    importModuleDynamically: experimentalModules
      ? async (specifier) => {
          if (asyncESM === undefined) lazyLoadESM();
          const loader = await asyncESM.loaderPromise;
          return loader.import(specifier, normalizeReferrerURL(filename));
        }
      : undefined,
  });

  // for __dirname in a.js
  var dirname = path.dirname(filename);
  // for require in a.js
  var require = makeRequireFunction(this);
  var depth = requireDepth;
  if (depth === 0) stat.cache = new Map();
  var result;
  if (inspectorWrapper) {
    result = inspectorWrapper(
      compiledWrapper,
      this.exports,
      this.exports,
      require,
      this,
      filename,
      dirname
    );
  } else {
    // a.js is really running here
    // So, this.exports is a function defined in a.js
    // result is undefined
    result = compiledWrapper.call(
      this.exports,
      this.exports,
      require,
      this,
      filename,
      dirname
    );
  }
  if (depth === 0) stat.cache = null;
  // Maybe this return is useless
  return result;
};
```

## Summary

1. when you use `require('path_to_file')`, it's same as `module.require('path_to_file')`

   > you can try it :)

2. `module.require` will call `Module._load` if `path_to_file` is valid

3. `Module._load` will do the following things:

   1. Calculating the absolute path(`filename`) of `path_to_file`.
   2. Return cache if cache exists, otherwise continue.
   3. Return native module if `filename` is native module name, otherwise continue.
   4. New a module object for `filename`.
   5. Add the module object to the cache.
   6. Call `tryLoadModule`.

   **Notice**: step 2 is the reason why every time call require('something'), we always get exactly the same returned, if it would resolve to the same file

4. `tryLoadModule` call `module.load`.

5. `module.load` will do the following things:

   1. Update `module.filename`.
   2. Update `module.paths`, see [this](https://nodejs.org/api/modules.html#modules_loading_from_node_modules_folders).
   3. Get the extension of `filename`, default `'.js'`.
   4. Call `Module._extensions[extension]`.

6. `Module._extensions['.js']` will get the content of the `filename`, and call `module._compile`.

7. `module_compile` will do the following things:

   1. Wrap the content, see [this](https://nodejs.org/api/modules.html#modules_the_module_wrapper).

   2. Compile the wrapped code, we get a function(`compiledWrapper`).

   3. Prepare two variables -- `dirname`, `require`.

      - `var dirname = path.dirname(filename);`
      - `var require = makeRequireFunction(this);`

   4. Call the function -- `compiledWrapper`.

      ```javascript
      compiledWrapper.call(
        this.exports,
        this.exports,
        require,
        this,
        filename,
        dirname
      );
      ```

      > "this" point to the module object of filename

So, the module object of `target` will be changed, and `require` will return `module.exports`.

## Reference

### updateChildren

```js
function updateChildren(parent, child, scan) {
  var children = parent && parent.children;
  if (children && !(scan && children.includes(child))) children.push(child);
}
```

### Module

```js
function Module(id, parent) {
  this.id = id;
  this.exports = {};
  this.parent = parent;
  updateChildren(parent, this, false);
  this.filename = null;
  this.loaded = false;
  this.children = [];
}
```

### Module.\_extensions

```js
// Native extension for .js
Module._extensions[".js"] = function (module, filename) {
  var content = fs.readFileSync(filename, "utf8");
  module._compile(stripBOM(content), filename);
};

// Native extension for .json
Module._extensions[".json"] = function (module, filename) {
  var content = fs.readFileSync(filename, "utf8");
  try {
    module.exports = JSON.parse(stripBOM(content));
  } catch (err) {
    err.message = filename + ": " + err.message;
    throw err;
  }
};

// Native extension for .node
Module._extensions[".node"] = function (module, filename) {
  return process.dlopen(module, path.toNamespacedPath(filename));
};
```
