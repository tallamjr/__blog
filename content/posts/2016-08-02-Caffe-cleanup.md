---
title: "Caffe cleanup: The UNIX way"
author: "Tarek Allam"
date: 2016-08-02
draft: true
category: tutorials
tags: [programming, unix]
---

*This post gives a run through of the steps taken to clean the Caffe output for
use in analysis. A script is present at the end that should create the desired
CSV files.*

<!--more-->

**Note, about a week after I had developed this code and data processing
pipeline, I discovered Caffe has a file to clean the stdout. Please see the
following [post on screen]({{ site.url }}{{ site.baseurl }}{% post_url 2016-08-10-Leaving-EC2-running %})
for a simplier solution. I will leave this post online as I did learn some cool UNIX tricks along
the way of trying to solve this problem**

When Caffe is running, it sends a lot of information to standard out. It would be
useful to have this information so that we can plot the loss as a function of
number of iterations.

Thankfully, \*NIX systems are perfect for this thing and with a combination of
`ex`, `vi` and `awk` one can produce neat CSV files that can be used in a wider
pipeline which produces plots and graph depicting the data.

The first thing is to obtain the complete stdout of when training a model. This
can either be done by redirecting the output with `>` to a file. One issue with
simply doing redirection, is that the user is unable to monitor the output in
real-time as it is all sent to the plaintext file. An alternative is the`tee`
command which would send to both stdout and redirect to a file.
I personally like to use a `tmux` command `capture-pane -S -3000` which
captures the pane output up to 3000 lines back. Then the `save-buffer
filename.txt` saves it into a text file. *I prefer this option as it allows me
to easily save the output file locally, as I will most likely be training a
model remotely*

One we have a output file, there needs to be some manual cleaning up before
`ex`, `vim` and `awk` can be put to work. Below is the head and tail of the
output file to show the form that it is in before further commands are run.

```less
I0801 12:33:48.354249  1902 caffe.cpp:251] Starting Optimization
I0801 12:33:48.354272  1902 solver.cpp:279] Solving SRCNN
I0801 12:33:48.354282  1902 solver.cpp:280] Learning Rate Policy: fixed
I0801 12:33:48.354704  1902 solver.cpp:337] Iteration 0, Testing net (#0)
I0801 12:33:49.088923  1902 solver.cpp:404]     Test net output #0: loss =
2.31261 ( 1 = 2.31261 loss)

...

I0801 15:24:54.089038  1902 sgd_solver.cpp:106] Iteration 43300, lr = 0.0001
^CI0801 15:25:14.116219  1902 solver.cpp:454] Snapshotting to binary proto file
RICNN/model/955-gz-optical-99/RICNN_iter_43386.caffemodel
I0801 15:25:14.227645  1902 sgd_solver.cpp:273] Snapshotting solver state to
binary proto file RICNN/model/955-gz-optical-99/RICNN_iter_43386.solverstate
I0801 15:25:14.228083  1902 solver.cpp:301] Optimization stopped early.
I0801 15:25:14.228106  1902 caffe.cpp:254] Optimization Done.

```

Then, create a file called `cmds.vim`. This will hold the commands that `vim`
will execute in order. The file contents is shown here:

```vim
:g/Snapshotting/d
:g/lr/d
:g/net/d
:wq
```

Then if we run the following commands...


```less
vim -E -s cleaned-caffe-output.txt < cmds.vim && awk '{print $6 "\t" $9 "\t"
$11}' cleaned-caffe-output.txt > nice.csv

```

It should result into creating a nice CSV file of the form:

```less

0,	2.12786
100,	0.793442
200,	1.10943
300,	0.577052
400,	0.55242
500,	1.18805
600,	1.07201
700,	0.563231
800,	1.26472
900,	0.703732

...
```

This can then be used with other programming languages to plot the loss as a
function of iterations. An example of such a file is shown below:


```python
# Import packages.
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas

mpl.rc('font',family='Tahoma')
# Create a new figure.
plt.figure()
ax = plt.gca()
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')
ax.xaxis.set_ticks_position('bottom')
ax.yaxis.set_ticks_position('left')

## Read in data from CSV file.
data = pandas.read_csv('training-loss-955-p20.csv')
data_error = pandas.read_csv('testing-loss-955-p20.csv')
# x :: Choose every row in the the first, or zeroth column.
iterations = data.ix[:, 0]
iterations_error = data_error.ix[:, 0]
# y :: Choose every row in the the second colum. Index 1.
training_loss = data.ix[:, 1]
testing_loss = data_error.ix[:, 1]

plt.plot(iterations, training_loss, color="blue", linewidth=0.75, linestyle="-",
label="Training Error")
plt.plot(iterations_error, testing_loss, color="red", linewidth=0.75,
linestyle="-", label="Testing Error")

plt.xlabel('Iterations')
plt.ylabel('Loss')
plt.legend(loc='upper right', frameon=False)
plt.title('Euclidien Loss v No. of Iterations')
# Save figure.
plt.savefig('loss-955-p20.png')


```

As can be seen from the above code, there is a separate set of commands that are
required to create *testing v iterations*. To create that CSV file, more manual
manipulation is required but is outlined in the following steps.

1. Open the cleaned caffe output file.
2. Run `qqjj14<Shift>Vd500@qggqa/net<Return>d200@a`
3. Save file to remove whitespace.
4. Align first row.
5. Type, `ggqs0jji<Backspace><Esc>500@s`

Then the output should be a good looking csv. It will need to be saved with the
correct file extension when all is done.

### REFS

[ex command](http://www.computerhope.com/unix/uex.htm)
[Executing VIM commands in a shell script](http://stackoverflow.com/questions/18860020/executing-vim-commands-in-a-shell-script)
[Run a series of vim commands at command line](http://stackoverflow.com/questions/23235112/how-to-run-a-series-of-vim-commands-from-command-prompt)
[Edit files as part of a wider
pipeline](http://vi.stackexchange.com/questions/788/how-to-edit-files-non-interactively-e-g-in-pipeline)
