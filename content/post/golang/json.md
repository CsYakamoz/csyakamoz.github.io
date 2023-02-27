---
title: "Json In Golang"
date: 2023-02-24T20:40:35+08:00
tags: ["json", "golang"]
---

这里仅记录个人认为重要的点:)

更详细的说明, 请查阅官方文档: [`encoding/json`](https://pkg.go.dev/encoding/json)

## 基本知识

默认的类型映射:

- Boolean -> JSON booleans
- Floating point, integer -> JSON numbers
- String -> JSON strings
- Array, slice -> JSON arrays
  - []byte -> base64-encoded string
  - nil slice -> JSON null
- Struct -> JSON objects

### Struct Field's Tag with JSON

序列化 Struct 时, 只处理 `Exported Field`, 即首字母大写的字段

默认情况下, json 的 key 等价于字段名, 其他情况看如下说明:

```plaintext
// Field appears in JSON as key "myName".
Field int `json:"myName"`

// Field appears in JSON as key "myName" and
// the field is omitted from the object if its value is empty,
// as defined above.
Field int `json:"myName,omitempty"`

// Field appears in JSON as key "Field" (the default), but
// the field is skipped if empty.
// Note the leading comma.
Field int `json:",omitempty"`

// Field is ignored by this package.
Field int `json:"-"`

// Field appears in JSON as key "-".
Field int `json:"-,"`
```

注意:

1. empty 指: false, 0, nil pointer, nil interface value, empty array, slice, map or string
2. 如果 key-name 是仅由 Unicode 字母、数字和 ASCII 标点符号（引号、反斜杠和逗号除外）组成的非空字符串, 则使用该 key-name, 否则使用 field-name

TODO: JSON Tag 支持 `string`, 即 `json:",string"`, 尚未清楚其作用

## 序列化

### `json.Marshal`

sig: `func Marshal(v any) ([]byte, error)`

使用场景: 返回 `v` 的 JSON 编码

```go
type Message struct {
	Name string
	Body string
	Time int64
}

func main() {
	msg := Message{"Alice", "Hello", 8008208820}
	jsonBytes, _ := json.Marshal(msg)
	fmt.Println(string(jsonBytes)) // {"Name":"Alice","Body":"Hello","Time":8008208820}
}
```

### `json.NewEncoder`

sig: `func NewEncoder(w io.Writer) *Encoder`

使用场景: 将 `v` 的 JSON 编码写到 `w` 中

```go
type Message struct {
	Name string
	Body string
	Time int64
}

func main() {
	msg := Message{"Alice", "Hello", 8008208820}
	encoder := json.NewEncoder(os.Stdout)
	_ = encoder.Encode(&msg) // {"Name":"Alice","Body":"Hello","Time":8008208820}
}
```

## 反序列化

### `json.Unmarshal`

sig : `func Unmarshal(data []byte, v any) error`

使用场景: 解析 JSON 编码数据并将结果存储到 `v` 指向的值

```go
type Message struct {
	Name string
	Body string
	Time int64
}

func main() {
	jsonData := []byte(`{"Name":"Alice","Body":"Hello","Time":8008208820}`)
	var msg Message
	_ = json.Unmarshal(jsonData, &msg)
	fmt.Println(msg) // {Alice Hello 8008208820}
}
```

### `json.NewDecoder`

sig: `func NewDecoder(r io.Reader) *Decoder`

使用场景: 从 `r` 读取并解析 JSON 编码数据

```go
func main() {
	const jsonStream = `
	{"Name": "Ed", "Text": "Knock knock."}
	{"Name": "Sam", "Text": "Who's there?"}
	{"Name": "Ed", "Text": "Go fmt."}
	{"Name": "Sam", "Text": "Go fmt who?"}
	{"Name": "Ed", "Text": "Go fmt yourself!"}
`
	type Message struct {
		Name, Text string
	}
	dec := json.NewDecoder(strings.NewReader(jsonStream))
	for {
		var m Message
		if err := dec.Decode(&m); err == io.EOF {
			break
		} else if err != nil {
			log.Fatal(err)
		}
		fmt.Printf("%s: %s\n", m.Name, m.Text)
	}
}
```

output:

```plaintext
Ed: Knock knock.
Sam: Who's there?
Ed: Go fmt.
Sam: Go fmt who?
Ed: Go fmt yourself!
```

> 来源: [Example-Decoder](https://pkg.go.dev/encoding/json#example-Decoder)

## Indent

> 以下不做过多解释

### `json.MarshalIndent`

sig: `func MarshalIndent(v any, prefix, indent string) ([]byte, error)`

### `json.Indent`

sig: `func Indent(dst *bytes.Buffer, src []byte, prefix, indent string) error`

### `SetIndent`:

sig :`func (enc *Encoder) SetIndent(prefix, indent string)`

## 自定义序列化/反序列化函数

根据需求分别实现对应 interface 即可:

```go
type Marshaler interface {
	MarshalJSON() ([]byte, error)
}

type Unmarshaler interface {
	UnmarshalJSON([]byte) error
}
```

### 使用场景举例

序列化/反序列化 `time.Time` 类型, 但希望时间字符串不是 [RFC 3339](https://rfc-editor.org/rfc/rfc3339.html)

```go
type Demo struct {
	Created time.Time
}

func main() {
	jsonData := []byte(`{"created": "2017-11-24 10:47:49"}`)
	var d Demo
	err := json.Unmarshal(jsonData, &d)
	if err != nil {
		log.Fatal(err)
	}
}
```

运行如上代码, 将会得到类似如下的报错:

```plaintext
parsing time "\"2017-11-24 10:47:49\"" as "\"2006-01-02T15:04:05Z07:00\"": cannot parse " 10:47:49\"" as "T"
```

解决方案:

1. 新增 `FlexTime` 类型, 并实现 `Marshaler`, `Unmarshaler` 接口

   ```go
   type FlexTime time.Time

   func (t FlexTime) MarshalJSON() ([]byte, error) {
   	format := time.Time(t).Format(`"2006-01-02 15:04:05"`)
   	return []byte(format), nil
   }

   func (t *FlexTime) UnmarshalJSON(data []byte) error {
   	original, err := time.Parse(`"2006-01-02 15:04:05"`, string(data))
   	if err != nil {
   		return err
   	}

   	*t = FlexTime(original)
   	return nil
   }

   func (t *FlexTime) Time() time.Time {
   	return time.Time(*t)
   }
   ```

2. `Created` 类型替换为 `FlexTime`

   ```go
   type Demo struct {
   	Created FlexTime
   }
   ```

如此便可

<details>
  <summary>点击查看完整代码</summary>

```go
type FlexTime time.Time

func (t FlexTime) MarshalJSON() ([]byte, error) {
	format := time.Time(t).Format(`"2006-01-02 15:04:05"`)
	return []byte(format), nil
}

func (t *FlexTime) UnmarshalJSON(data []byte) error {
	original, err := time.Parse(`"2006-01-02 15:04:05"`, string(data))
	if err != nil {
		return err
	}

	*t = FlexTime(original)
	return nil
}

func (t *FlexTime) Time() time.Time {
	return time.Time(*t)
}

type Demo struct {
	Created FlexTime
}

func main() {
	jsonData := []byte(`{"created": "2017-11-24 10:47:49"}`)
	var d Demo
	err := json.Unmarshal(jsonData, &d)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("d.Created.Time(): %v\n", d.Created.Time())

	jsonData, err = json.MarshalIndent(&d, "", "    ")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("jsonData: %v\n", string(jsonData))
}
```

运行代码可得如下输出:

```plaintext
d.Created.Time(): 2017-11-24 10:47:49 +0000 UTC
jsonData: {
    "Created": "2017-11-24 10:47:49"
}
```

</details>
