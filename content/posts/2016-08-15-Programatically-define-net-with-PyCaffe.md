---
layout: post
title: "Programatically define nets with PyCaffe"
author: "Tarek Allam"
date: 2016-08-15
category: tutorials
tags: [programming, deep-learning]
cover:  /media/Python-Programming-Language-Art.jpg
---

*Discussed here is an overview of the PyCaffe interface and how it can be used
to programatically create a prototxt file that defines a net architecture.*

<!--more-->

<!--<img src="{{site.baseurl}}/media/the-general-problem.png">-->
<img src="http://imgs.xkcd.com/comics/the_general_problem.png">
<div class="figcaption">xkcd: The General Problem</div>

Caffe is notorious for its minimal documentation, especially when it comes to
the Python and MATLAB interfaces. Shown here will be a collection of examples
and steps on how to create the *prototxt* file that hold the information about
the net architecture. This file is then fed into Caffe to begin training.

### Why Define Programatically?

As mentioned in an early post about the different frameworks, when it comes to
manipulating or changing aspects of your network in Caffe, complex networks can
be very fiddly to ensure everything is connected correctly. That is why it is
usually best to let a computer handle this job for us. In order to do this, we
need a form of abstraction and this is done in this case with PyCaffe, the
python interface for Caffe.

**NOTE:** This will only work on your machine if you have compiled Caffe with
Python support and linked the Python path in your `.bashrc` like so:
```bash
export PYTHONPATH="${PYTHONPATH}:$CAFFEHOME/caffe/python"
```

### Example: Re-implementaion of SRCNN

In order to showcase the variables and items that can be define, I shall
re-implement the original *9-1-5* convolutional neural network defined by Dong
et al. Their original `SRCNN_net.prototxt` is show here:

<!--<pre><code class="language-json">-->
```json

name: "SRCNN"
layer {
  name: "data"
  type: "HDF5Data"
  top: "data"
  top: "label"
  hdf5_data_param {
    source: "examples/SRCNN/train.txt"
    batch_size: 128
  }
  include: { phase: TRAIN }
}
layer {
  name: "data"
  type: "HDF5Data"
  top: "data"
  top: "label"
  hdf5_data_param {
    source: "examples/SRCNN/test.txt"
    batch_size: 2
  }
  include: { phase: TEST }
}

layer {
  name: "conv1"
  type: "Convolution"
  bottom: "data"
  top: "conv1"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 0.1
  }
  convolution_param {
    num_output: 64
    kernel_size: 9
    stride: 1
    pad: 0
    weight_filler {
      type: "gaussian"
      std: 0.001
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}

layer {
  name: "relu1"
  type: "ReLU"
  bottom: "conv1"
  top: "conv1"
}

layer {
  name: "conv2"
  type: "Convolution"
  bottom: "conv1"
  top: "conv2"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 0.1
  }
  convolution_param {
    num_output: 32
    kernel_size: 1
    stride: 1
    pad: 0
    weight_filler {
      type: "gaussian"
      std: 0.001
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}

layer {
  name: "relu2"
  type: "ReLU"
  bottom: "conv2"
  top: "conv2"
}

layer {
  name: "conv3"
  type: "Convolution"
  bottom: "conv2"
  top: "conv3"
  param {
    lr_mult: 0.1
  }
  param {
    lr_mult: 0.1
  }
  convolution_param {
    num_output: 1
    kernel_size: 5
    stride: 1
    pad: 0
    weight_filler {
      type: "gaussian"
      std: 0.001
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}

layer {
  name: "loss"
  type: "EuclideanLoss"
  bottom: "conv3"
  bottom: "label"
  top: "loss"
}
```

We shall now use PyCaffe to recreate this architecture and prototxt file to show
how one can programatically define a network. This will then be used and
extended for further development when it comes to defining our own networks and
architectures.

First we do our imports.

```bash
import sys
import caffe
from caffe import layers as cl
```

Then we want a function that defines the network. This will take in as input the
source H5 file containing our training data. We will also define a batch size of
the data. Note the `include` argument, this will tell the network to run in
TRAIN phase, we will discuss TEST phase later.

```python
def create_neural_net(input_file, batch_size=128):
    net = caffe.NetSpec()

    net.data, net.label = cl.HDF5Data(batch_size=batch_size, source=input_file,
            ntop=2, include=dict(phase=caffe.TRAIN))
```

Once that has been done, we move onto creating the actual layers of our network.
Notice the `conv1` layer is directly connected to the `relu1` layer. Also notice
how the parameters are set such as kernel size, stride, etc.

{% highlight python %}
    ## Convolutional Layer 1
    net.conv1 = cl.Convolution(net.data, num_output=64, kernel_size=9, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu1 = cl.ReLU(net.conv1, in_place=True)
{% endhighlight %}

Below is the rest of the layers, up to where we return everything as a prototxt
file.

<pre><code class="language-python">
    ## Convolutional Layer 2
    net.conv2 = cl.Convolution(net.relu1, num_output=32, kernel_size=1, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu2 = cl.ReLU(net.conv2, in_place=True)

    ## Convolutional Layer 3
    net.conv3 = cl.Convolution(net.relu2, num_output=1, kernel_size=5, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':0.1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu3 = cl.ReLU(net.conv3, in_place=True)

    ## Euclidean Loss
    net.loss = cl.EuclideanLoss(net.conv3, net.label)

    return net.to_proto()
</code>
</pre>

After return the data in prototxt form, we need to write it to a file. That is
done with the code below which also allows us to input arguments when running
this program. The inputs are the source of the training data being used (in h5
format) and the name of the file your wish to write to.


```python
if __name__=='__main__':
    train_h5list_file = sys.argv[1]
    output_file = sys.argv[2]
    # batch_size = 50
    with open(output_file, 'w') as f:
        f.write(str(create_neural_net(train_h5list_file)))
```

Annoyingly, it is not possible to programtically set the TRAIN and TEST phases
programatically, this is an [open
issue](https://github.com/BVLC/caffe/issues/4044) with pycaffe.

However, once the file has been created, one can simply copy the TRAIN
phase information and paste the test phase information below, like so:

<pre><code class="language-json">
...

layer {
  name: "data"
  type: "HDF5Data"
  top: "data"
  top: "label"
  hdf5_data_param {
    source: "path/to/test.txt"
    batch_size: 2
  }
  include: { phase: TEST }
}

...
</code>
</pre>

Now we have a fully (*almost*) way of defining our network architectures so that
we can create new and quirky models to be tested. This will be invaluable when
developing novel architectures and experimenting with different networks.

Finally to create the resulting prototxt file, run the command as follows:

<pre><code class="language-bash">
python define_net.py training_set.h5 resulting_net.prototxt
</code>
</pre>

### References.

To make this program, inspiration and tips have been drawn from these weblinks:

- [caffe: model definition: write same layer with different phase using caffe.NetSpec()](http://stackoverflow.com/questions/36844968/caffe-model-definition-write-same-layer-with-different-phase-using-caffe-netsp)
- [Where is layer module defined in
  PyCaffe](http://stackoverflow.com/questions/36187825/where-is-layer-module-defined-in-pycaffe)
- [Fully connected multi layer perceptron using PyCaffe](http://stackoverflow.com/questions/36960196/fully-connected-multi-layer-perceptron-using-pycaffe/36963681#36963681)
- [Cheat sheet for caffe/pycaffe](http://stackoverflow.com/questions/32379878/cheat-sheet-for-caffe-pycaffe)
- [How To Programmatically Create A Deep Neural Network In Python Caffe](https://prateekvjoshi.com/2016/04/19/how-to-programmatically-create-a-deep-neural-network-in-python-caffe/)
- [Net_Spec()](https://github.com/BVLC/caffe/blob/master/python/caffe/test/test_net_spec.py)


### Full file

```python
import sys
import caffe
from caffe import layers as cl

def create_neural_net(input_file, batch_size=128):
    net = caffe.NetSpec()

    net.data, net.label = cl.HDF5Data(batch_size=batch_size, source=input_file,
            ntop=2, include=dict(phase=caffe.TRAIN))

    ## Convolutional Layer 1
    net.conv1 = cl.Convolution(net.data, num_output=64, kernel_size=9, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu1 = cl.ReLU(net.conv1, in_place=True)

    ## Convolutional Layer 2
    net.conv2 = cl.Convolution(net.relu1, num_output=32, kernel_size=1, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu2 = cl.ReLU(net.conv2, in_place=True)

    ## Convolutional Layer 3
    net.conv3 = cl.Convolution(net.relu2, num_output=1, kernel_size=5, stride=1,
            pad=0, weight_filler=dict(type='gaussian', std=0.001),
            param=[{'lr_mult':0.1},{'lr_mult':0.1}],
            bias_filler=dict(type='constant', value=0))
    net.relu3 = cl.ReLU(net.conv3, in_place=True)

    ## Euclidean Loss
    net.loss = cl.EuclideanLoss(net.conv3, net.label)

    return net.to_proto()

if __name__=='__main__':
    train_h5list_file = sys.argv[1]
    output_file = sys.argv[2]
    # batch_size = 50
    with open(output_file, 'w') as f:
        f.write(str(create_neural_net(train_h5list_file)))
```
