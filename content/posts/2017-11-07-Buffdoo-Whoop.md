---
author: Tarek Allam
categories:
- tutorials
image: images/posts/2017-11-07-Buffdoo-Whoop/bufdo.jpg
date: "2017-11-07T00:00:00Z"
tags:
- programming
- unix
- cloud
title: I think I can use :bufdo for that
draft: true
---

*This is a brief overview of the `screen` command with applications to Caffe and
AWS.*

<!--more-->

In the world of deep learning frameworks, there exist the big four frameworks:

* Caffe
* Torch
* Theano
* TensorFlow

There are many other deep learning libraries, but
these have come to dominate, so the focus will be on them. This is
meant to be a brief overview and the reader is encouraged to explore the
documentation of each framework for detailed guides on getting started.

## Frameworks

### Caffe

[Caffe Homepage](http://caffe.berkeleyvision.org/)

WRITTEN IN: C++ / CUDA<br>
INTERFACE: Command Line, Matlab, Python<br>
LICENSE: BSD<br>

Caffe sprang out of the Berkeley Vision and Learning Center. It was the
initial work on [DeCAF: A Deep Convolutional Activation Feature
for Generic Visual Recognition.](https://arxiv.org/pdf/1310.1531.pdf)
and the attempt to reimplement [AlexNet](https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks.pdf)
that eventually evolved into Caffe.

The Caffe framework appeals to many as it is possible to train big and powerful
models without writing any code. The essence of Caffe models are placed into
.prototxt files. These can be thought of as large json files that contain all
the information about the architecture of the model. An example of which is
shown below:


```bash

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

...
```

Although it may seem nice to be able to define the model in this way, complex
architectures can become very hard to deal with. The reader is encouraged to
look at the ResNet-152 model .prototxt file found
[here](https://github.com/KaimingHe/deep-residual-networks/blob/master/prototxt/ResNet-152-deploy.prototxt) to get a feel for how
difficult it may be to keep track of.

Having said this however, the Caffe framework benefits from having a large
repository of pre-trained neural network models suited for a variety of image
classification tasks, called the Model Zoo, which is available on [Github.](https://github.com/BVLC/caffe/wiki/Model-Zoo)

Caffe is well suited to convolutional neural nets but there has been recent
development to extend its capabilities to work well with other network structures
such as RNNs etc.

PROS -->

* Good for feedforward networks.
* Good for finetuning existing networks.
* Train models without writing any code.
* Python interface available.

CONS -->

* Need to write C++ / CUDA for new GPU layers.
* Need to be comfortable reading through C++ source code.
* Not good for recurrent networks at the moment.
* Cumbersome for big networks.
* Painful to write custom layers in Caffe.

### Torch

[Torch Homepage](http://torch.ch)

WRITTEN IN: Lua<br>
INTERFACE: Python<br>
LICESNCE: BSD<br>

Torch was developed by academics at NYU and is written in a functional
scripting language called Lua. It uses [just-in-time (JIT) compiation](https://en.wikipedia.org/wiki/Just-in-time_compilation) to make things really fast.
Due to the relatively simple syntax of Lua, Torch benefits from a nice
easy-to-use feel. This has also meant that many community contributed packages
exists for Torch, as well as plenty of support for functionality.

Torch can import trained neural network models from Caffe's Model Zoo, using
[LoadCaffe.](https://github.com/szagoruyko/loadcaffe)

One key feature about Torch is that it is very modular, and that packages can be
pieced together. Torch is broken down into modules. Modules are classes written
in Lua, easy to read and write. The key modules are:

  [nn](https://github.com/torch/nn) - Neural Network module.

  [cunn](https://github.com/torch/cunn) - For running on the GPU.

  [optim](https://github.com/torch/optim) - For a selection of gradient descents.

Torch works with the concept of Torch tensors which is analogous to numpy
arrays. A useful feature of Torch is according to Torch, GPUs are just another
datatype and so the same code can be written for both CPU and GPU.

PROS -->

* Most of the library code is in Lua, relatively easy to read.
* Lots of modular pieces that are easy to combine.
* Easy to write your own layers and run on GPU.
* Lots of pre-trained models.

CONS -->

* Lua (Functional language - not everyones cup of tea)
* Less plug and play than Caffe - You usually write your own training code.
* Not great for RNNs.

### Theano

[Theano Homepage](http://deeplearning.net/software/theano/)

WRITTEN IN: Python<br>
INTERFACE: Python, with high level libraries available.<br>
LICENSE: [BSD/MIT/Apacahe
combo](http://deeplearning.net/software/theano/LICENSE.html)<br>

Theano was developed by academics at University of Montreal and is all about the
computational graph and symbolic programming.

A comment from a Reddit
[post](https://www.reddit.com/r/MachineLearning/comments/2c9x0s/best_framework_for_deep_neural_nets/) discussing deep learning framewroks explains
the benefits well.

*Theano is all about computational graph and symbolic programming.
The main reason for this is that it supports automatic differentiation: you just
specify your architecture and loss function in an almost declarative way, and
you get the gradients for free. For me personally, this has been invaluable in
experimenting with various exotic loss functions, nonlinearities and
architectures.*

One of the key points to take from this is the symbolic differentiation which is
very appealing.

Theano also works with shared variables that exist in the computational graph
and persist from call to call. This helps with any overhead caused by transfer
of data from the CPU to the GPU and back.

Theano is not strictly a neural network library, but rather a Python library
that makes it possible to implement a wide variety of mathematical abstractions.
Because of this, Theano has a high learning curve, so it is recommended to use neural
network libraries built on top of Theano that have a more gentle learning curve.

The common libraries are:

- [Keras](http://keras.io/)
- [Lasagne](https://lasagne.readthedocs.io/en/latest/)
- [Py2learn](https://github.com/lisa-lab/pylearn2) - Built on top of Theano for a more plug and play feel.

Multi-GPU use in Theano can be tricky to set up, but there is a work around
outlined on [Github.](https://github.com/Theano/Theano/wiki/Using-Multiple-GPUs)

PROS -->

* Python + numpy
* Computational graph is nice abstraction.
* RNNs fit nicely in computational graph.
* High level wrappers available:
    * Keras
    * Lasagne
* Since it is just Python, it has access to good scientifc python libraries.

CONS -->

* Raw Theano is somewhat low-level (Can be a plus in some cases)
* Error messages can be unhelpful - debugging can be hard due to library abstraction.
* Large models can have long compile times.
* Much 'fatter' than Torch; more magic and hand waving going on.
* Patchy support for pretrained models.

#### TUTORIALS:

[Theano tutorials](https://github.com/Newmu/Theano-Tutorials)

### TensorFlow

[TensorFlow Homepage](https://www.tensorflow.org/)

WRITTEN IN: Python, C++<br>
INTERFACE: Yes<br>
LICENSE: Apache 2.0<br>

TensorFlow was developed at Google by the Google Brain team.
Although under proprietary development for some years,
it has recently been released under an Apache 2.0 license
and is gaining a lot of popularity. TensorFlow is very similar to Theano in that
it focuses on the concept of a computational graph, and the idea of symbolic
programming. TensorFlow uses 'Placeholders' which would be analogous to the
symbolic variables in Theano.

TensorFlow offers a good amount of documentation for installation, as well as
learning materials and tutorials which are aimed at helping beginners understand
some of the theoretical aspects of neural networks, and getting TensorFlow set
up and running relatively painlessly.

High level wrappers exist to get up and running even quicker. One such is
[tflearn.](http://tflearn.org/)

In addition, the wrapper mentioned above for Theano, Keras, now works with
TensorFlow too. The author of Keras has recently ported Keras to
TensorFlow. This means the Keras framework now has both TensorFlow and Theano as
backends. Keras is a particularly easy to use deep learning framework. Now, any
model previously written in Keras can now be run on top of TensorFlow.

The author of Keras, Francois Chollet, has put together a guide to using Keras
as part of TensorFlow which can be found
[here.](http://blog.keras.io/keras-as-a-simplified-interface-to-tensorflow-tutorial.html)

In terms of speed, TensorFlow is slower than Theano and Torch, but is in the
process of being improved. Future releases will likely see performance similar
to Theano and Torch.(For speed comparisons see [summary](#summary) section)

A very handy feature of TensorFlow is TensorBoard. This tool helps visualise the
parameters and loss function per epoch of your model.

PROS -->

* Python + numpy
* Computational graph abstraction, like Theano; great for RNNs
* Much faster compile times than Theano.
* TensorBoard for visualisation.
* Data AND model parallelism - best of all frameworks for this.
* Distributed models (but not open source YET)
* Designed and written by software engineers.

CONS -->

* Not many pre-trained models.
* Much 'fatter' than torch; more magic.
* Slower than other frameworks at the moment.

#### TUTORIALS:

- [TensorFlow tutorials and code examples for beginners](https://github.com/aymericdamien/TensorFlow-Examples)

**NOTE:** One gotcha I discovered when installing TensorFlow in a virtual env means
that when it comes to plotting, matplotlib will have [issues.](http://matplotlib.org/faq/virtualenv_faq.html)
This may be OSX specific but something to be
aware of.

**NOTE:** If installing more than one framework, be careful to only have one version
of *protobuf* installed on your computer. This creates huge conflicts if there is
found to be more than one version and will crashes. However, this seems to only
really be a problem with Caffe and TensorFlow.

## <a name="summary"></a>Summary and other resources.

From the points raised above it can be seen that the choice of framework is
largely based on the problem one is hoping to solve. Other considerations such
as speed and ease of use may or may not be important.

If speed is of concern, a comparative study of the different frameworks can be
found [here.](https://github.com/soumith/convnet-benchmarks)

A general comparison of the different frameworks can be found on [wikipedia.](https://en.wikipedia.org/wiki/Comparison_of_deep_learning_software)

As mentioned at the start, there are many more deep learning libraries out in
the wild, and the reader is encouraged to explore. A good set of resources I
used in creating this post are listed below:

- [KD Nuggets](http://www.kdnuggets.com/2015/06/popular-deep-learning-tools.html)
- [Reddit - Best framework for Deep Neural
  Nets?](https://www.reddit.com/r/MachineLearning/comments/2c9x0s/best_framework_for_deep_neural_nets/)
- [Stanford CNN lecture 12 - Deep Learning Library
  Review](https://www.youtube.com/watch?v=kDB5ErpJCW0&index=12&list=PLrZmhn8sSgye6ijhLzIIXiU9GNaIwbF8B&ab_channel=Alex)

In addition, the reader may be interested in exploring one of the many other
frameworks out there such as:

- [cuda-convnet2](https://code.google.com/p/cuda-convnet/)
- [Toronto Deep Learning
  convnet](https://github.com/TorontoDeepLearning/convnet)
- [deeplearning4j](http://deeplearning4j.org/dl4jcluster.html)

Futher discussion on these and more frameworks are outlined in this
[blog.](https://medium.com/@techvu/deep-machine-learning-libraries-and-frameworks-5fdf2bb6bfbe#.16nss99jl)

A list of deep learning libraries grouped by language can be found
[here.](http://www.teglor.com/b/deep-learning-libraries-language-cm569/)

Below is a snippet from [FastML blog](http://fastml.com/torch-vs-theano/) that I found useful to think of differences
of how each framework has been adopted and to help me decide which I may use for
my research.

*Torch v Theano
Besides the language gap, that's one of the reasons that you don't see that much
Torch usage apart from Facebook and DeepMind. At the same time libraries using
Theano have been springing up like mushrooms after a rain (you might want to
take a look at Sander Dieleman's Lasagne and at blocks). It is hard to beat the
familiar and rich Python ecosystem.*

*Caffe has a pretty different target. More mass market, for people who want to
use deep learning for applications. Torch and Theano are more tailored towards
people who want to use it for research on DL itself.*


