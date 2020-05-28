---
author: Jason McEwen
categories:
- tutorials
date: "2015-08-07T00:00:00Z"
draft: true
image: images/posts/2015-08-07-Publishing-code-to-GitHub/github.jpeg
tags:
- codes
- computing
title: Publishing code to GitHub
---

To make codes in our private git repos public we push a particular branch to [GitHub](https://github.com).

<!--more-->

![github_logo](/images/posts/2015-08-07-Publishing-code-to-GitHub/github.jpeg)


Firstly create a branch that will be pushed to GitHub.  For example, create a new `public` branch by:
`git checkout -b public`

Alternatively, a new branch can be created from a specific commit or tag, e.g., by:
`git checkout -b public v1.1`

Once a public GitHub repo has been created, add a remote for the GitHub repo:
`git remote add github https://github.com/astro-informatics/bianchi.git`

Push the public branch to GithHub:
`git push github public`

Note, **do not** push other branches to GitHub, otherwise they will become public.

[GitHub pages](https://pages.github.com/) are used for the code website.  This website should replicate the files in the `doc` directory of the code.  To replicate the `doc` directory on a `gh-pages` branch, in order to deploy the website, run:
`git subtree push --prefix doc github gh-pages`

For an example of a code made available on GitHub see the [ssht](https://github.com/astro-informatics/ssht) code and the corresponding [website](http://astro-informatics.github.io/ssht).
