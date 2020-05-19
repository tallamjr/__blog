# Blog

This blog has been developed using a combination of `markdown` `vim` and `hugo`

Blog posts are arranged such that a new post will live in the `posts` directory with
`YYYY-MM-DD-TITLE.md` format. They all contain front matter like so:

```bash
---
draft: false
title: "Packaging Scala Applications"
author: "Tarek Allam Jr"
date: 2020-02-10
category: tutorials
tags: [reproducibility, programming]
---
```

To deploy a new post, run `./deploy.sh` script which removes contents of the `public` directory
and then rebuilds the site using `hugo` command. The new additions to the rebuilt `public` directory
will then be added, committed and pushed to `gh-pages`

This workflow was set up using `git worktree` command, using this
[guide](https://gohugo.io/hosting-and-deployment/hosting-on-github/)

### Testing

In order to link check, please run: `muffet --verbose http://localhost:{$BLOG_PORT}/blog/`
