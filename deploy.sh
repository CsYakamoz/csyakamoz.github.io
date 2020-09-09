#!/usr/bin/env bash
set -euo pipefail

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

rm -rf public/*

# Build the project.
hugo -t mogege # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd public
# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site $(date +"%Y-%m-%d %H:%M:%S") CST"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..
