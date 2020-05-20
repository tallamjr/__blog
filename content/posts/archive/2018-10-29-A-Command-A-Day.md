---
author: Tarek Allam
categories:
- tutorials
image: images/posts/2018-09-09-Cadence-Wars-III/tSNE-kraken-2026.png
draft: true
date: Sun Sep  9 02:49:59 BST 2018
tags:
- programming
- unix
- cloud
title: A Command A Day...
mathjax : true
---

*Living Life a the Command Line*

<!--more-->

<img src="/images/posts/2018-08-07-Cadence-Wars-II/thecall.png" style="float: right;margin: 0px 0px 15px 20px;">

# A Command A Day...

This page contains useful UNIX commands I pick up along my journey of living
life on the command line.

- `lsof`

The _List Open Files_ command is a great utility to see what files are currently
open on the file system. It can also check which ports are currently being used
and by what process.

```bash
lsof -ti:8888
```

- `git pull -r`

Instead of the default `git fetch` followed by `git merge`, we can specify that
the second step is a _rebase_ instead of a _merge_ after fetching all the remote
object references.

- `pip install .`
