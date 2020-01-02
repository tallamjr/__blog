---
author: Tarek Allam
categories:
- tutorials
image: images/posts/2016-09-28-hello-world/sunshine-clouds.jpg
date: "2016-09-28T00:00:00Z"
draft: true
title: Hello World!
---

*This is a post that reminds me of the cool things that can be done with Jekyll
and GitHub pages. It will be a random assortment of tricks and tips to remind me
of how things can be achieved using this format.*

<!--more-->

<img src="/images/posts/2016-09-28-hello-world/helloworld.jpg">
<div class="figcaption">Hello!</div>

I have been wanting to put together a website/blog for a very long time now, but
I have always been put off by the likes of WordPress and other *simple* website
and blogging platforms. The reason is that is that I do not like for details of
how things work to be completely hidden away from me, if I am using something I
like to understand (to some extent) what is going on.

I also knew that if I were to put together a website and/or blog, I wanted to be
able do a few key things. The first being that I wanted to be able write every
post in plain text. I didn't really mind the format too much but I wanted to be
able to version control my posts and I wanted to write everything in **vim**. My
love affair with **vim** would not allow me to give this up and so I searched
for a suitable option, a blog I could write all in vim and version control with
**git**.

Alas, Jekyll and Github pages to the rescue!

Jekyll allows you to do this and this.

Github pages allows you to do this and this.

# Writing A Post

When creating a file, the filename should be of the form `year-mm-dd-Title-of-post.md`, e.g.
`2016-09-28-hello-world.md`. Putting together a post is simple and each post begins with some meta data
defined in [YAML](http://yaml.org/). An example of which can be seen below:

``` yaml
---
layout: post
title: "Creating a post"
author: "Tarek Allam"
date: 2016-09-28
category: tutorials
tags: [computing, web]
cover: /media/posts/2016-09-28-hello-world/sunshine-clouds.jpg
---
```

When you push your updates to the `git` repository [Jekyll](http://jekyllrb.com)
will be run automatically to generate the site from the raw Markdown and the
live site will be updated.

So... that's it.  *All you need to do to add a post is drop a file into `_post`
and commit to the `git` repository.*


The rest of this post simply offers a few tips for adding posts, focusing on:

- [Etiquette](#etiquette)
- [Formatting](#formatting)
- [Images](#images)
- [Data](#data)
- [Math](#math)


## <a name="etiquette"></a>Etiquette

When writing posts, especially when related to ongoing research developments,
consider writing the post for yourself in a couple of years time when you've
forgotten the specific details.  Although you might not wish to go into
excruciating detail about your post, do make sure you include enough detail so
that you could completely understand all the points raised in the post when
re-reading it years later.  This is particularly useful when you in fact do come
back to read your posts in the future but also helps your collaborators and
colleagues to understand your posts.


Do also add `categories` and `tags` to your posts so that you can easily search them.  Each post will have one and only one `category` but may have multiple `tags`.  These are defined in the YAML front matter.


## <a name="formatting"></a>Formatting

Markdown supports a wide variety of formatting.  See for example, the cheat sheet available [here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).  Some of the most common formatting cases are reviewed briefly below.

#### Sections

Sections are produced by prefixing section titles with `#` characters, with the number of characters representing the level of the section.

#### Highlighting

*Italic* is produced by `*Italic*`.

**Bold** is produced by `**Bold**`.


#### Lists

You can include itemised lists simply by prefixing items with `-` or `*`:

- like this
- this
- and this

and also numbered lists:

1. like this
2. this
3. and this

Indenting can be used to produce nested lists.

#### Tables

Tables can be entered straightforwardly:

| Heading 1     | Heading 2     | Heading 3     |
| :------------ |:-------------:| -------------:|
| left-aligned  | centred       | right-aligned |
| left-aligned  | centred       | right-aligned |


#### Code

Code can be highlighted, like the following:

{{< highlight ruby >}}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{{< / highlight >}}

You can even specify the language to get the appropriate syntax highlighting.


#### Styleguide

For furhter details about formatting and appearance when rendered see the [styleguide](/styleguide).


#### Horizontal rules

Rules like the following can be produced by `---`, `___` or `***`.

**

## <a name="images"></a>Images

Images should be saved in the `/images/posts/` directory, in a subdirectory matching the post, e.g. `/images/posts/2015-07-19-Creating-a-post/`.   Images can then be included in the post in a variety of ways.

Images can be included by pure Markdown like:

`![ref]({{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png)`

resulting in:

![ref]({{ site.url }}{{ site.baseurl }}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png)

or by html, like:

`<img class="centered" src="{{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" />`

resulting in:

<img class="centered" src="{{ site.url }}{{ site.baseurl }}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" />

Note that it is necessary to specify the site url and baseurl using `{{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}`, so that the image can be found when the site is deployed.

Finally, you might like to resize images by specifying the proportion of the text width to use, like

`<img class="centered" src="{{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" width="20%"/>`

resulting in:

<img class="centered" src="{{ site.url }}{{ site.baseurl }}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" width="20%"/>


## <a name="data"></a>Data

Data associated with a post should be saved in the `/data/posts/` directory, in a subdirectory matching the post, e.g. `/data/posts/2015-07-19-Creating-a-post/`.

Data can then be linked to by:

`[Data link]({{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}/data/posts/2015-07-19-Creating-a-post/fssht.pdf)`

resulting in:

[Data link]({{ site.url }}{{ site.baseurl }}/data/posts/2015-07-19-Creating-a-post/fssht.pdf)

If possible, please try to avoid adding large files.


## <a name="math"></a>Math

Thanks to [MathJax](http://www.mathjax.org), equations may be entered using standard Latex.  For further details see [http://docs.mathjax.org/en/latest/](http://docs.mathjax.org/en/latest/).

Equations are defined by the delimiters `\\(...\\)` for in-line equations and `\\[...\\]` or `$$...$$` for displayed
equations.

For example, the following equation:

$$a^2 + b^2 = c^2$$

is generated by:

{{< highlight r >}}
$$a^2 + b^2 = c^2$$
{{< / highlight >}}

while the in-line equation \\( a^2 + b^2 = c^2 \\) is generated by `\\( a^2 + b^2 = c^2 \\)`.

Note that for subscripts you need to escape the underscore character, e.g. \\( A\_b \\) is generated by `\\( A\_b \\)`.
