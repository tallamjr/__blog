---
author: Tarek Allam
categories:
- tutorials
date: 2018-08-06
draft: true
tags:
- programming
- unix
- cloud
title: "Running Jupyter Notebooks on Hypatia"
---

*Jupyter Notebooks on Hypatia*

<!--more-->

# Hypatia + Jupyter

<img src="https://www.bleepstatic.com/content/posts/2018/06/15/Data-Center.jpg">

<a name="introduction"></a>
## Jupyter Notebooks

Jupyter notebooks are a great way to do exploratory analysis and even better to
showcase reproducible research. Sometimes the hardware available locally is not
enough and it would be ideal if one could run an analysis on a much more
powerful machine and/or on a cluster.

First one needs to run an interactive job. This can be done by simply running
`qsub -I` on _Hypatia_. This will give the following (similiar, not exact)
output:

{{< highlight bash >}}
(hypatia) 15:56:24 ✔ ~  :: qsub -I
qsub: waiting for job 8023.hypatia.hpc.phys.ucl.ac.uk to start
qsub: job 8023.hypatia.hpc.phys.ucl.ac.uk ready

[tallam@compute-0-17 ~]$
{{< / highlight >}}

One should take note of the compute node that has been assigned, in the example
above this is *compute-0-17*

Something that should be noted is that Python is note automatically loaded on
the compute nodes on Hypatia, so running the command shown below will result in
an error:

{{< highlight bash >}}
[tallam@compute-0-17 ~]$ which juypter
juypter: Command not found.
{{< / highlight >}}

Therefore, one needs to run `module load python` in order to load the Python
distribution, now the running `which jupyter` will yield:

{{< highlight bash >}}
[tallam@compute-0-17 ~]$ which python
/share/apps/anaconda/python3.6/bin/python
{{< / highlight >}}

To see what other versions and distributions are available, one can run `module
avail`.

Now we have jupyter available, we can start a notebook on the compute node by
running the following:

{{< highlight bash >}}
jupyter notebook –-no-browser –-port=8888
{{< / highlight >}}

Then, we need to open a ssh connection to the cluster and the computer node
_compute-0-17_ (Done locally)

{{< highlight bash >}}
(laptop) 15:59:29 :: ssh -t -t tallam@hypatia-login.hpc.phys.ucl.ac.uk -L 8888:localhost:8888 ssh compute-0-17 -L 8888:localhost:8888
{{< / highlight >}}

Following that, we should be able to tunnel from local machine to the Jupyter notebook.
Direct your browser on your local machine to http://localhost:8888/. You
should now see the Jupyter notebook view of the filesystem on the cluster.

If it asks for a password, it may require you to copy and paste a token that
would have been displayed when initially running `jupyter notebook -–no-browser -–port=8888`
Grab this and pate into your browser, and voilà, you are running a notebook on
the cluster.

## Using `snmachine`

The next steps in order to get `snmachine` to work is the following.

First ensure make sure your are in a `bash` shell. This can be determined by
running:

{{< highlight bash >}}
$ echo $0
{{< / highlight >}}
which will print the shell to stdout.

If not in `bash`, just typing:

{{< highlight bash >}}
$ bash
{{< / highlight >}}

will take you into a `bash` shell.

Assuming that `python setup.sh develop` and a jupyter environment has been set
up prior, you should now be able to run `source activate snmachine`

Now that you are _in_ a `snmachine` environment we can now start the notebook
(note the code below shows the Jupyter instance we are using is within the
environment and not global)

{{< highlight bash >}}
(snmachine) (hypatia) 21:21:29 ✘ ~/snmachine (issue/57/cadence-classification)
:: which jupyter
/home/tallam/.conda/envs/snmachine/bin/jupyter
{{< / highlight >}}

_FINALLY_
It is important to remember to close the connection when all is done, `ctrl-c`
