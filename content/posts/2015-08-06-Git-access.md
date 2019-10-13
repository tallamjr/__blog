---
author: Jason McEwen
categories:
- tutorials
date: "2015-08-06T00:00:00Z"
draft: true
image: images/posts/2015-08-06-Git-access/git_logo.png
tags:
- computing
title: Git access
---

We make extensive use of [git](https://git-scm.com/) for version control, for all manner of things, including codes, papers, websites and wikis.  For more about git, see the [git book](https://git-scm.com/book/en/v2), especially the first three chapters.

<!--more-->

![git_logo](/images/posts/2015-08-06-Git-access/git_logo.png)

## Hosting

All git repositories are hosted on the astro-informatics server, with host alias [https://www.astro-informatics.org](`https://www.astro-informatics.org`).

Only secure access is supported, so you need to connect via `https` (`http` access is disabled).


## Cloning

You should be able to clone each git repo with the following command*:

<pre>
git clone https://www.astro-informatics.org/git/&lt;repo_type&gt;/&lt;repo_name&gt;.git
</pre>


where `<repo_type>` is the repo path (typically `src`, `doc` or `www`) and `<repo_name>` is the name of the repo.

For example, to clone the repo housing this wesite, run:

<pre>
git clone https://www.astro-informatics.org/git/www/wiki_astro-informatics.git
</pre>

You will be prompted for a username and password.

 &#42; See the important note about [SSL below](#ssl).


## Access and public version

All repos on the astro-informatics server have access restricted.  You can only access the repo if the appropraite permissions are set.  General public access is not provided.

Public versions of codes, e.g. [ssht](http://astro-informatics.github.io/ssht/), are made available on [GitHub](https://github.com/).  Versions made available on GitHub are simply a push of a specific branch of the private repo (the corresponding branch is usually named `public` or `release`), as will be explained in more detail in a subsequent post.


## <a name="ssl"></a>SSL

Note that the astro-informatics server does not support [SSL certification](https://en.wikipedia.org/wiki/Transport_Layer_Security).

You therefore need to turn off git SSL verification when accessing repos.

This can be done by setting the environmental variable `GIT_SSL_NO_VERIFY` to true.

If you wanted this setting for all git repos, you could set this in your, e.g., .cshrc file.  Otherwise you can set the environmental variable just before or during the access to the git repo, e.g., by

<pre>
env GIT_SSL_NO_VERIFY=true git clone https://www.astro-informatics.org/git/&lt;repo_type&gt;/&lt;repo_name&gt;.git
</pre>

If an environmental variable is not set separately, you will need to prefix all git commands that access the remote server in this manner.

Another possibility, once you've cloned a git repo, is to enforce this setting by adding the following to the .git/config file:

<pre>
[http]
      sslVerify = false
</pre>



