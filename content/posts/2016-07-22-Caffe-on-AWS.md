---
layout: post
title: "Installing Caffe in the cloud"
author: "Tarek Allam"
date: 2016-07-22
category: tutorials
tags: [programming, cloud, deep-learning]
cover: /media/posts/2016-07-22-Caffe-on-AWS/caffe-on-aws.png
---

*This post will run through the steps taken to get [Caffe](http://caffe.berkeleyvision.org/)
up and running on an AWS instance.*

<!--more-->

**Note, this post may be considered observe since Amazon Web Services have
recently realised an instance called
[p2](https://aws.amazon.com/blogs/aws/new-p2-instance-type-for-amazon-ec2-up-to-16-gpus/)
which is specifically designed for
Deep Learning computation in mind. One can configure up to 16 GPUs to run jobs
that use the lasted deep learning frameworks such as Caffe and Tensorflow all
pre-installed and ready to go. I do mention that there have been attempts to
bundle these frameworks into standalone AMIs and now it seems AWS have taken on
the job and bundled everything together for us. Therefore I would recommend
checking out the p2 instance instead of attempting to install everything
yourself. I will leave this post up however to remind myself of how I manged to
get things working before, and perhaps remind myself not to do it again**

*This post is under the assumption the reader has an AWS account set-up and is
familiar with connecting to the machine via `ssh`.*

Whilst waiting for dependencies to be installed on ARGO, I felt it would be a
good idea to run through the process of installing and compiling Caffe on Linux
myself to better understand the software and hardware requirements. In addition,
installing and running on my own instance gave peace of mind that I would not be
affecting anyone else that wants to use the machine.

The first step is to launch a GPU instance. If it is preferred to compile and run
without GPU support, a normal free tier micro instance would suffice. The
instance I went for was a `g2.2xlarge`.

After playing with a various pre-built options such as [docker](https://hub.docker.com/r/kaixhin/caffe/), [nvidia-docker](https://github.com/NVIDIA/nvidia-docker),
[AMI](https://github.com/BVLC/caffe/wiki/AWS-EC2-GPU-enabled-Caffe-AMI)s etc. it was found to be much simpler to just use a normal AMI, install the
dependencies and compile from source. The decision as to which AMI, or Linux
distribution again came down to the one that gave me least headaches - Ubuntu.
(RHEL was first attempted as this is the distribution used on ARGO, but this was found to be very
troublesome, especially for someone who's not a Sysadmin)

When this is launched and you have successfully logged in, the following steps
are required to get all the dependencies and drivers installed.

### Install dependencies

Update the package manager.

`$ sudo apt-get update`

Following this, download the dependencies, outlined on [Caffe installation
webpage](http://caffe.berkeleyvision.org/install_apt.html)

```bash
$ sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev \
libopencv-dev libhdf5-serial-dev protobuf-compiler
$ sudo apt-get install --no-install-recommends libboost-all-dev
$ sudo apt-get install libatlas-base-dev
$ sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
```

### Get Caffe

If it is not installed already, install `git`. To check if it is already
installed run `which git` the result should be the path to where the binary is
stored. If nothing appears run `sudo apt-get install git`

Now we have `git` installed, we can git clone Caffe. So, choose which directory
you would like Caffe to be installed and run:

```bash
$ git clone https://github.com/BVLC/caffe.git
```

### Compilation

Now that we have the Caffe repo, we need to compile it for our hardware. The
first thing is to modify the Makefile. It is highly recommended to make a copy of
the original file to have a backup in place.

```bash
$ cd caffe/ && cp Makefile.config.example Makefile.config
```

Next, change the Makefile to suit your system
```bash
$ vim Makefile.config
```

My complete [Makefile.config](#mymakefile) can be found at the bottom of this post.

Following that we run the `make` command.
```bash
$ make all -j8
```

Where the flag `-j8` is the number of parallel threads for compilation
(a good choice for the number of threads is the number of cores in your
machine).

```bash
$ make test

CXX src/caffe/test/test_infogain_loss_layer.cpp
CXX src/caffe/test/test_euclidean_loss_layer.cpp
CXX src/caffe/test/test_benchmark.cpp
CXX src/caffe/test/test_io.cpp

...

LD .build_release/src/caffe/test/test_reduction_layer.o
LD .build_release/src/caffe/test/test_platform.o
LD .build_release/src/caffe/test/test_gradient_based_solver.o
LD .build_release/cuda/src/caffe/test/test_im2col_kernel.o
```

```bash
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
$ make runtest

...

[----------] Global test environment tear-down
[==========] 1096 tests from 150 test cases ran. (69745 ms total)
[  PASSED  ] 1096 tests.
[100%] Built target runtest
```

### Set up GPU

Determine the GPU that is on the system and download the appropriate driver from
the official [NVIDIA
webpage](http://www.nvidia.com/Download/index.aspx?lang=en-us)

```bash
$ lspci | grep -i nvidia

00:03.0 VGA compatible controller: NVIDIA Corporation GK104GL [GRID K520] (rev a1)
```

Here we see that we have a NVIDIA GPU attached. We need to check that the
Operating System can talk to it, i.e. that is has the correct drivers installed.

```bash
$ nvidia-smi -q | head

modprobe: ERROR: could not insert 'nvidia_352': Unknown symbol in module, or
unknown parameter (see dmesg)
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver.
Make sure that the latest NVIDIA driver is installed and running.
```

The above tells us that we still need to download and install the correct
drivers for the GPU that is on our system.

```bash
$ sudo apt-get update && sudo apt-get -y upgrade
$ sudo apt-get install -y linux-image-extra-`uname -r`
$ sudo /bin/bash ./NVIDIA-Linux-x86_64-367.35.run
$ sudo apt-get install nvidia-352 nvidia-modprobe nvidia-settings
```

Now, when we run the test again, we get:
```bash
$ nvidia-smi -q | head

==============NVSMI LOG==============

Timestamp                           : Sat Jul 23 17:41:45 2016
Driver Version                      : 352.93

Attached GPUs                       : 1
GPU 0000:00:03.0
    Product Name                    : GRID K520
    Product Brand                   : Grid

```

### Train models

Now all drivers are installed. Caffe can now be run. See [next post]({{ site.url
}}{{ site.baseurl }}{% post_url 2016-07-23-CPU-vs-GPU %}) about
comparing the difference in compute time for training on the CPU only and on the
GPU.

## <a name="mymakefile"></a> Makefile.config

<pre><code class="language-makefile">

## Refer to http://caffe.berkeleyvision.org/installation.html
# Contributions simplifying and improving our build system are welcome!

# cuDNN acceleration switch (uncomment to build with cuDNN).
# USE_CUDNN := 1

# CPU-only switch (uncomment to build without GPU support).
# CPU_ONLY := 1

# uncomment to disable IO dependencies and corresponding data layers
# USE_OPENCV := 0
# USE_LEVELDB := 0
# USE_LMDB := 0

# uncomment to allow MDB_NOLOCK when reading LMDB files (only if necessary)
#	You should not set this flag if you will be reading LMDBs with any
#	possibility of simultaneous read and write
# ALLOW_LMDB_NOLOCK := 1

# Uncomment if you're using OpenCV 3
# OPENCV_VERSION := 3

# To customize your choice of compiler, uncomment and set the following.
# N.B. the default for Linux is g++ and the default for OSX is clang++
# CUSTOM_CXX := g++

# CUDA directory contains bin/ and lib/ directories that we need.
CUDA_DIR := /usr/local/cuda
# On Ubuntu 14.04, if cuda tools are installed via
# "sudo apt-get install nvidia-cuda-toolkit" then use this instead:
# CUDA_DIR := /usr

# CUDA architecture setting: going with all of them.
# For CUDA < 6.0, comment the *_50 lines for compatibility.
CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
		-gencode arch=compute_20,code=sm_21 \
		-gencode arch=compute_30,code=sm_30 \
		-gencode arch=compute_35,code=sm_35 \
		-gencode arch=compute_50,code=sm_50 \
		-gencode arch=compute_50,code=compute_50

# BLAS choice:
# atlas for ATLAS (default)
# mkl for MKL
# open for OpenBlas
BLAS := atlas
# Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
# Leave commented to accept the defaults for your choice of BLAS
# (which should work)!
# BLAS_INCLUDE := /path/to/your/blas
# BLAS_LIB := /path/to/your/blas

# Homebrew puts openblas in a directory that is not on the standard search path
# BLAS_INCLUDE := $(shell brew --prefix openblas)/include
# BLAS_LIB := $(shell brew --prefix openblas)/lib

# This is required only if you will compile the matlab interface.
# MATLAB directory should contain the mex binary in /bin.
# MATLAB_DIR := /usr/local
# MATLAB_DIR := /Applications/MATLAB_R2012b.app

# NOTE: this is required only if you will compile the python interface.
# We need to be able to find Python.h and numpy/arrayobject.h.
PYTHON_INCLUDE := /usr/include/python2.7 \
		/usr/lib/python2.7/dist-packages/numpy/core/include
# Anaconda Python distribution is quite popular. Include path:
# Verify anaconda location, sometimes it's in root.
# ANACONDA_HOME := $(HOME)/anaconda
# PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
		# $(ANACONDA_HOME)/include/python2.7 \
		# $(ANACONDA_HOME)/lib/python2.7/site-packages/numpy/core/include \

# Uncomment to use Python 3 (default is Python 2)
# PYTHON_LIBRARIES := boost_python3 python3.5m
# PYTHON_INCLUDE := /usr/include/python3.5m \
#                 /usr/lib/python3.5/dist-packages/numpy/core/include

# We need to be able to find libpythonX.X.so or .dylib.
PYTHON_LIB := /usr/lib
# PYTHON_LIB := $(ANACONDA_HOME)/lib

# Homebrew installs numpy in a non standard path (keg only)
# PYTHON_INCLUDE += $(dir $(shell python -c 'import numpy.core; print(numpy.core.__file__)'))/include
# PYTHON_LIB += $(shell brew --prefix numpy)/lib

# Uncomment to support layers written in Python (will link against Python libs)
# WITH_PYTHON_LAYER := 1

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib

# If Homebrew is installed at a non standard location (for example your home directory) and you use it for general dependencies
# INCLUDE_DIRS += $(shell brew --prefix)/include
# LIBRARY_DIRS += $(shell brew --prefix)/lib

# Uncomment to use `pkg-config` to specify OpenCV library paths.
# (Usually not necessary -- OpenCV libraries are normally installed in one of the above $LIBRARY_DIRS.)
# USE_PKG_CONFIG := 1

# N.B. both build and distribute dirs are cleared on `make clean`
BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# Uncomment for debugging. Does not work on OSX due to https://github.com/BVLC/caffe/issues/171
# DEBUG := 1

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
Q ?= @

</code>
</pre>
