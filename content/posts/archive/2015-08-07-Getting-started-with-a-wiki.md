---
author: Jason McEwen
categories:
- tutorials
date: "2015-08-07T00:00:00Z"
draft: true
image: images/posts/2015-08-07-Getting-started-with-a-wiki/wiki.jpeg
tags:
- web
- computing
title: Getting started with a wiki
---

Wikis are updated simply by pushing to the appropriate git repository.

<!--more-->

![git_logo](/images/posts/2015-08-07-Getting-started-with-a-wiki/wiki.jpeg)

Each wiki (i.e. Jekyll website) has its own git repo.  However, these are managed in a master admin repo, where each wiki is a separate branch (this allows admin updates to be pushed to all repos in a straightforward manner).

Within the separate repos for each wiki, the wiki is stored on a branch matching the name of the wiki (*without* the `www_` prefix).  For example, for `wiki_astro-informatics`, the wiki is stored on the `astro-informatics` branch.

We illustrate the process of updating wikis using this `astro-informatics` wiki as an example .

1. Clone the repo locally:
    ```bash
	git clone https://www.astro-informatics.org/git/www/wiki_astro-informatics.git
    ```

2. Checkout the `astro-informatics` branch (i.e. the branch that matches the wiki name):
    ```bash
	git checkout astro-informatics
    ```

3. Update the wiki and commit to the local clone (to add a post simply add markdown files to the `_posts` directory, as descibed in [this post]({{ site.url }}{{ site.baseurl }}{% post_url 2015-07-19-Creating-a-post %})).

4. Push updates to the appropriate branch (i.e. the branch with name matching the wiki name):
    ```bash
	git push origin astro-informatics

    ```

The online version of the wiki will then be updated automatically by a post-receive hook that runs after the push.
