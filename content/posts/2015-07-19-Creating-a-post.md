---
author: Jason McEwen
categories:
- tutorials
date: "2015-07-19T00:00:00Z"
draft: true
image: images/posts/2015-07-19-Creating-a-post/postbox.jpeg
tags:
- computing
- web
title: Creating a post
---

To create a new post, all you need to do is drop a new [Markdown](https://en.wikipedia.org/wiki/Markdown) file in the `_posts` directory.

<!--more-->

The file should be named `year-mm-dd-Title-of-post.md`, e.g. `2015-07-19-Creating-a-post.md`, and must contain a [YAML](http://yaml.org/) preamble specifying the properties of the page.  An example of YAML front matter is the following:

```bash
---
layout: post
title: "Creating a post"
author: "Jason McEwen"
date: 2015-07-19
category: tutorials
tags: [computing, web]
image: 2015-07-19-Creating-a-post/postbox.jpeg
---
```

As discussed in the [post on Jeykll]({{ site.url }}{{ site.baseurl }}{% post_url 2015-07-18-Introduction-to-Jekyll %}), when you push your updates to the `git` repository [Jekyll](http://jekyllrb.com) will be run automatically to generate the site from the raw Markdown and the live site will be updated.

So... that's it.  *All you need to do to add a post is drop a file into `_post` and commit to the `git` repository.*

The rest of this post simply offers a few tips for adding posts, focusing on:

- [Etiquette](#etiquette)
- [Formatting](#formatting)
- [Images](#images)
- [Data](#data)
- [Math](#math)


## <a name="etiquette"></a>Etiquette

When writing posts, especially when related to ongoing research developments, consider writing the post for yourself in a couple of years time when you've forgotten the specific details.  Although you might not wish to go into excruciating detail about your post, do make sure you include enough detail so that you could completely understand all the points raised in the post when re-reading it years later.  This is particularly useful when you in fact do come back to read your posts in the future but also helps your collaborators and colleagues to understand your posts.

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

***



## <a name="images"></a>Images

Images should be saved in the `/images/posts/` directory, in a subdirectory matching the post, e.g. `/images/posts/2015-07-19-Creating-a-post/`.   Images can then be included in the post in a variety of ways.

Images can be included by pure Markdown like:

`![ref](/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png)`

resulting in:

![ref](/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png)

or by html, like:

`<img class="centered" src="{{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" />`

resulting in:

<img class="centered" src="/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" />

Note that it is necessary to specify the site url and baseurl using `{{ "{{ site.url " }}}}{{ "{{ site.baseurl " }}}}`, so that the image can be found when the site is deployed.

Finally, you might like to resize images by specifying the proportion of the text width to use, like

`<img class="centered" src="/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" width="20%"/>`

resulting in:

<img class="centered" src="/images/posts/2015-07-19-Creating-a-post/mathjax_logo.png" width="20%"/>


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
