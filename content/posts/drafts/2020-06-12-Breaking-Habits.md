---
draft: true
title: "Git in the Habbit"
author: "Tarek Allam Jr"
date: 2020-06-12
category: tutorials
tags: [reproducibility, programming]
---

Some years ago, I decided to make a couple changes to how I write my commits and organise my git
logs. This post goes over how breaking a couple habits has vastly improved my software development
and data science workflow.

<!--more-->

# <a name="git-intro"></a>`git`

<img src="https://imgs.xkcd.com/comics/git.png" style="float: right;margin: 0px 0px 10px 15px;">

For the uninitiated, `git` is a source code versioning system created by the legendary Linus
"`linux`" Torvalds. In a previous post <INSERT-HERE> I mentioned how influential `vim` has been on
my software engineering journey, `git` is on an equal footing there, if not more so, as learning
`git`, and learning it well, has trulely liberated me in becoming the developer I am today and
allows me to grow.

For the uninitiated, `git` is a source code versioning system created by the legendary Linus
"`linux`" Torvalds. In a previous post <INSERT-HERE> I mentioned how influential `vim` has been on
my software engineering journey, `git` is on an equal footing there, if not more so, as learning
`git`, and learning it well, has trulely liberated me in becoming the developer I am today and
allows me to grow.

For the uninitiated, `git` is a source code versioning system created by the legendary Linus
"`linux`" Torvalds. In a previous post <INSERT-HERE> I mentioned how influential `vim` has been on
my software engineering journey, `git` is on an equal footing there, if not more so, as learning
`git`, and learning it well, has trulely liberated me in becoming the developer I am today and
allows me to grow.

<center>
{{< tweet 1247652738428817410 >}}
</center>

"Right, OK, yeah yeah" I hear you cry; "what was this _one_ habit" you were on about!?"

# <a name="git-intro"></a>1. Dropping `-m`

Going from ~~`git commit -m`~~ to just `git commit`

## <a name="git-intro"></a>Commit Templates

# <a name="git-intro"></a>2. Embrace `rebase`

<center>
<img src="https://static01.nyt.com/images/2016/08/05/us/05onfire1_xp/05onfire1_xp-articleLarge-v2.jpg?quality=75&auto=webp&disable=upscale">
</center>

# <a name="git-intro"></a>3. Branching with Purpose

* `issue/123/desc`
* `feature/456/desc`
* `feature/456/issue/789/desc`

Helping to remember, might be considered cosmetic like the rebase. But doing this has changed how I
think about, plan ahead for code changes or updates.

```bash
16:48:05 ✔ ~/www/blog/.git/refs (GIT_DIR!) :: tree .
.
├── heads
│   ├── dev
│   ├── develop
│   ├── gh-pages
│   ├── issue
│   │   ├── 1
│   │   │   └── sbt-pkg
│   │   ├── 13
│   │   │   └── theme-change
│   │   └── 2
│   │       └── actions
│   └── master
├── remotes
│   └── origin
│       ├── dev
│       ├── develop
│       ├── gh-pages
│       ├── issue
│       │   ├── 1
│       │   │   └── sbt-pkg
│       │   ├── 13
│       │   │   └── theme-change
│       │   └── 2
│       │       └── actions
│       └── master
└── tags
    ├── v0.1.0
    └── v1.0.0

12 directories, 16 files

```

# <a name="git-intro"></a>Takeaways

Rule of thumb
<!-- {{< figure src="/blog/img/posts/2016-11-12-Matlab-R-Julia-Notebooks/newprojectlist.png" class="alignright">}} -->

<!-- - [Scala and SBT Introduction](#scala) -->
<!-- - [SBT-Native-Packager](#native) -->
<!-- - [Docker](#docker) -->

<!-- ```python -->
<!-- print(f"Numpy: {np.__version__}") -->
<!-- ``` -->

<!-- Say if I said something here -->

<!-- ```bash -->
<!-- $ echo "Hello World!" -->
<!-- ``` -->

<!-- ```scala -->
<!-- println("hello") -->
<!-- def somefunction(col: String) -->

<!-- val mate = Int 5 -->
<!-- ``` -->

