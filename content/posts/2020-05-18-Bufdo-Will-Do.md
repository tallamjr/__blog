---
draft: false
layout: post
title: "Ah bufdo; That'll do.."
author: "Tarek Allam Jr"
date: 2020-05-18
categories: [misc]
tags: [vim, processing, unix]
cover: "/img/posts/2020-05-18-Bufdo-Will-Do/cover.png"
---
A while ago I worked on a method to allow local writing of development logs in markdown, which I
could then upload to Github where my supervisor could take a look. Here are the steps..

<!--more-->

<!-- {{< figure src="/img/posts/2020-04-08-FINK/fink-architecture-20200206.png">}} -->
<!-- Testing [cardinality](/posts/glossary#cardinality) -->

# `:bufdo`

*Originally authored 2017-11-06*

{{< figure src="https://imgs.xkcd.com/comics/real_programmers.png">}}

In true vim-fan-boy fashion, I write my development logs in `vim` and then
like to have them render from within `vim`. To do this I use a plugin called
*InstantMarkdownPreview*. However, the syntax used to render images using this
plugin is different from the syntax generally required and used by Github.
Therefore, a workaround has been developed such that I write the logs locally on
a `local` branch, and then checkout to master and upon a `git push` some
undercover wizardry works behind the scenes.

Considering there could be potentially 100's or markdown files at some point,
whatever I do, I should future proof the method for when that day comes when I
have many files to edit at once. Enter `vim`'s `:bufdo` feature. Below is a
brief overview on the workflow required to be able to achieve this.

First, one needs a workflow where we have one `master` branch which will be used
to push Github markdown flavoured files to a remote repo, and `local` which will
have *InstantMarkdownPreview* type of markdown files that can be viewed locally
from within `vim` with the command `:InstantMarkdownPreview`

The *InstantMarkdown* file has the following syntax for displaying images:

```bash
![](a/raw/b/inc/screenshots/repo-clone-and-sync.png)
```

However, Github, does not care for the "a/raw/b" that prepends the path of where
the image is. So, one can have this is the `pre-push` file (found in `.git/hooks/pre-push`
that combines the efforts of `:bufdo` and git hooks to achieve a seamlessly flow from local to
Github markdown rendering.

`pre-push` looks like:
```bash
#!/bin/bash
vim -E -s *.md < cmds.vim && git commit -am "Changes made for Github rendering"
```
Where the contents of `cmds.vim` just contain the commands to be executed in `vim`
```bash
:bufdo %s/a\/raw\/b\///ge | update
```
Now this is all set up, one can do the following, create a local branch which be
used write the development logs and to view them in `vim`
```bash
git co -b local
```
Then when the respective files have been written, which paths to images looking
like so:

```bash
![](a/raw/b/inc/screenshots/repo-clone-and-sync.png)
```

One cane save these files, `git add` and `git commit` them, and then go to
master.

```bash
git co master
git merge local -X theirs
```
The `git merge local -X theirs` basically forces the merge even though we will
have conflicts relating to the different syntax.
A commit message will appear in `vim` asking to confirm the merge. Saving this,
and then doing a `git push` now does the job! The *new* syntax that `bufdo`
changes images to looks like the following:

```bash
![](inc/screenshots/repo-clone-and-sync.png)
```

Ready for Github :-)

*Note: A `git push --no-verify` may be required if changes are made to the repo
that don't invole the workflow described above. `--no-verify` allows one to skip
the git hook file `pre-push`*
