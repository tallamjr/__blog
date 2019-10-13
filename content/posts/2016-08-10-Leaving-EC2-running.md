---
layout: post
title: "Leaving EC2 Running"
author: "Tarek Allam"
date: 2016-08-10
category: tutorials
tags: [programming, unix, cloud]
---

*This is a brief overview of the `screen` command with applications to Caffe and
AWS.*

<!--more-->

{{< figure src="/img/posts/2016-08-10-Leaving-EC2-running/screen-unix.png" class="alignright">}}

Training convolutional neural nets can take time, a lot of time, which is fine
until you want to close your laptop for whatever reason, or you have to get a
broken pipe with `ssh`. Behold, `screen` to the rescue.

Simply `ssh` into the EC2 instance as usual and then run:


```bash
$ screen
```

Screen is a terminal multiplexer much like `tmux` but is from the GNU family.
This means it will most likely already be installed on most linux EC2 instances.

After running the screen command, you will be taken into a new *shell* where you
can execute and run programs as normal. Now, if you type `<ctrl-A> d` you will
be *detached* from that shell to the original one when you logged in. The job
will keep running in the *inner* shell. You can re-attached to this shell with
`screen -r`. Re-attaching can be done even if the connection is closed from the
user end or if a pipe is broke and you need to ssh back in. After shh'ing back
into the EC2 instance, run `screen -r` and you should re-attach to the running
shell.

To ensure the output of training a model of caffe is captured, one can run:

```less

/pathtocaffe/build/tools/caffe train --solver=solver.prototxt 2>&1 | tee
lenet_train.log

```

Then once the log files is collected run:

```less
python /pathtocaffe/tools/extra/parse_log.py lenet_train.log .

```

Following that, we can extract the meaningful data and make plots to visualise
the training and tests process.


```python
train_log = pd.read_csv("./lenet_train.log.train")
test_log = pd.read_csv("./lenet_train.log.test")
_, ax1 = subplots(figsize=(15, 10))
ax2 = ax1.twinx()
ax1.plot(train_log["NumIters"], train_log["loss"], alpha=0.4)
ax1.plot(test_log["NumIters"], test_log["loss"], 'g')
ax2.plot(test_log["NumIters"], test_log["acc"], 'r')
ax1.set_xlabel('iteration')
ax1.set_ylabel('train loss')
ax2.set_ylabel('test accuracy')

```

### References

- [Monitor training/validation process in  Caffe](http://stackoverflow.com/questions/31978186/monitor-training-validation-process-in-caffe)
