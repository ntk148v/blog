---
title: "Linux tools that you never knew you needed"
date: 2021-04-07T09:45:59+07:00
draft: false
---

## 1. bat - (cat alternative)

- [bat](https://github.com/sharkdp/bat): A cat(1) clone with syntax highlighting and Git integration.

## 2. fd - (find alternative)

- [fd](https://github.com/sharkdp/fd): a simple, fast and user-friendly alternative to `find`.

## 3. httpie - (wget/curl alternative)

- [httpie](https://httpie.io): a user-friendly command-line HTTP client for the API era. It comes with JSON support, syntax highlighting, persistent sessions, wget-like downloads, plugins, and more.
- Examples:

```bash
# Hello world
$ http httpie.io/hello
# Custom HTTP method, HTTP headers and JSON data
$ http PUT pie.dev/put X-API-Token:123 name=John
# Submitting forms
$ http -f POST pie.dev/post hello=World
# Upload a file using redirect input
$ http pie.dev/post < files/data.json
# ...
# For more examples, check out: https://httpie.io
```

## 4. ripgrep - (grep alternative)

- [ripgrep](https://github.com/BurntSushi/ripgrep): a faster `grep`. ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern. By default, ripgrep will respect your .gitignore and automatically skip hidden files/directories and binary files.
- [Benchmark](https://github.com/BurntSushi/ripgrep#quick-examples-comparing-tools).
- Examples:

```bash
# Basic use
$ rg fast README.md
# Regular expressions
$ rg 'fast\w+' README.md
# Recursive search - recursively searching the directory (current directory is default)
$ rg 'fn write\('
# ...
# For more examples, checkout: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
```

## 4. delta

- [delta](https://github.com/dandavison/delta): Code evolves, and we all spend time studying diffs. Delta aims to make this both efficient and enjoyable: it allows you to make extensive changes to the layout and styling of diffs, as well as allowing you to stay arbitrarily close to the default git/diff output.
