---
author: Jason McEwen
categories:
- tutorials
date: "2015-07-18T00:00:00Z"
draft: true
image: images/posts/2015-07-18-Introduction-to-Jekyll/jekyll_logo.png
tags:
- computing
- web
title: Introduction to Jekyll
---

The most important thing to know about Jekyll is that you don't need to know Jekyll.

<!--more-->

![jeykll_logo](/images/posts/2015-07-18-Introduction-to-Jekyll/jekyll_logo.png)

Although this wiki is built on [Jekyll](http://jekyllrb.com), you don't need to know Jekyll to add posts.  Jekyll runs on the raw text files that contain the content of the site and generates the corresponding static website ready to be served.

Adding a post is simply a matter of writing a [Markdown](https://en.wikipedia.org/wiki/Markdown) text file and dropping it into the appropriate location (the `_posts` directory).  When you push to the `git` repository, the appropriate magic[*](#magic) will automatically deploy your updates to the served version of the site.

It is therefore possible to avoid any interaction with Jekyll.  When writing posts in Markdown, you may want to consider using a Markdown-aware editor (e.g. [MacDown](http://macdown.uranusjr.com/)) so that you can get some idea of how your posts will appear.

However, if you want to [preview](#previewing) exactly how your updates will appear on the site, you may want to run Jekyll locally.


## <a name="previewing"></a>Previewing the site

To preview updates to the site on your local machine, you will need to run Jekyll locally.

You can do so simply by running the following in a terminal when in the parent directory of the site (e.g. in your local `git` clone):

{{< highlight r >}}
jekyll serve
{{< / highlight >}}

Then in any browser visit [http://localhost:4000/](http://localhost:4000/) to see the latest version of the site.  Jekyll should automatically rebuild the site when you make changes to the local source files (e.g. add or modify posts).  Simply refresh your browser to view the updates.

Further details can be found at [http://jekyllrb.com/docs/usage/](http://jekyllrb.com/docs/usage/).


## <a name="magic"></a>Magic

For those that are interested, the live site will be automatically updated following a `git` push by running a git hook on the server that firstly runs Jekyll to generate a new version of the site and then secondly replaces the existing live site with the newly built version.
