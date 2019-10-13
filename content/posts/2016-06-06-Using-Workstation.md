---
author: Christopher Wallis
categories:
- tutorials
date: "2016-06-06T00:00:00Z"
draft: true
image: images/posts/2016-06-06-Using_Workstation/matrix.png
tags:
- codes
- computing
title: Using Argo (workstation)
---

A guide to using Argo.

<!--more-->

![matrix](/images/posts/2016-06-06-Using_Workstation/matrix.png)

Here I've tried to collect all the knowledge about using the Argo in one post. If you have any problems please email/slack message me and we'll find out how to fix the problem and update this post to prevent it happening again.

## <a name="logging_on"></a>Logging On

### From outside the MSSL network

The easiest (and as far as I know the only) way to connect to the MSSL network externally is through the `gate`. This can be done by

{{< highlight bash >}}
ssh -Y user_name@gate.mssl.ucl.ac.uk
{{< / highlight >}}

for MACs and

{{< highlight bash >}}
ssh -X user_name@gate.mssl.ucl.ac.uk
{{< / highlight >}}

for LINUX machines. From this point you can then log in to Argo using

{{< highlight bash >}}
ssh user_name@msslld
{{< / highlight >}}



### From within the MSSL network

The easiest way to log on to Argo when connected to the MSSL network is through `ssh`

{{< highlight bash >}}
ssh -Y user_name@gate.mssl.ucl.ac.uk
{{< / highlight >}}

for MACs and

{{< highlight bash >}}
ssh -X user_name@gate.mssl.ucl.ac.uk
{{< / highlight >}}

for LINUX machines. This will allow you to run commands in the command line and open windows.

## <a name="environment"></a>Setting Up Your Environment

This section was worked out by Luke who helped me set up my environment on Argo. By detaul, Argo uses `tcsh` as standard for the terminal. I prefer bash therefore I set the terminal to bash by including the file below in my `.tcshrc` file.

{{< highlight bash >}}
#!/usr/bin/env tcsh
scl enable devtoolset-3 bash
{{< / highlight >}}

Then I have a `.bashrc` file that sets up my environment variables. I've copied my `.bashrc` file below with some comments as a guide.

{{< highlight bash >}}
#!/usr/bin/env bash
PS1="\u@\h:\w $"
# include sublime and cmake in the path
export PATH="$HOME/opt/sublime_text_3/:$HOME/opt/cmake/bin/:$PATH"

# includes python packages installed on Argo
export PYTHONPATH="${PYTHONPATH}:/unsafe1/opt/python_packages/lib/python2.6/site-packages"

# sets up the virtual environment for python
# this allows us to have a environment where we can install
# python packages without root access.
source /unsafe1/opt/virtualenv/bin/activate


# locations of libraries (this allows me to easily reference them in makefile's)
export code=/unsafe1/opt/
export SSHT=/unsafe1/opt/ssht
export SO3=/unsafe1/opt/so3/
export MATLAB=/usr/local/MATLAB/R2015b
export CFITSIO=/unsafe1/opt/cfitsio/
export HEALPIX=/unsafe1/opt/Healpix_3.30/

# I get lonely sometimes (plus it tells me it ran)
echo 'hello'
{{< / highlight >}}

## Leaving Jobs Running Remotely

There are a number of ways to leave a job running. The most simple is to use `screen`. If the job is a simple executable then you can use this to leave it running when you log off. For more details go to [here](http://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/).

If this is not possible or you want to leave many windows open ready for you then VNC is a useful tool. VNC is system that allows you to store a screen in the memory of the machine that you can then view from any other computer. This the way I run MATLAB code when not connected. I open a vnc session (see bellow) and then I can open a MATLAB window and start the job. If I disconnect the screen (and the MATLAB window) still exists.

Unfortunately the MSSL network will not allow VNC sessions to be viewed from another computer so I view the VNC session from Argo itself.

To start a VNC session use

{{< highlight bash >}}
vncserver -geometry <height>x<width>
{{< / highlight >}}

where you include the hight and width (in pixels) of the screen you want to create. If this is the first time you will be asked for a password to open the sessions. You will be told after the number of the session you have opened, you need this!

You can then open the sessions with,

{{< highlight bash >}}
vncviewer msslld.mssl.ucl.ac.uk:<number> &
{{< / highlight >}}

or

{{< highlight bash >}}
vncviewer localhost:<number> &
{{< / highlight >}}

You can change the resolution of a running session by running the following in a terminal running on the vnc session:

{{< highlight bash >}}
xrandr -s <height>x<width>
{{< / highlight >}}

To check valid geometries (i.e. width and heights), view the display preferences from the menu System > Preferences > Display.


## Transferring data to and from Argo

From within the MSSL network you can simply `scp` the files in the normal way e.g. to copy a file from Argo to my machine I can use

{{< highlight bash >}}
scp file_to_copy cwallis@mssl7:~/place/to/put/it/
{{< / highlight >}}

One catch is you need to have set your computer up to allow remote access before hand. For MACs you must go to System Preferences  -> Sharing, enable Remote Login.

In order to `scp` from offsite then you need to follow the instructions [here](http://www.mssl.ucl.ac.uk/www_computing/mssl_only/fom-serve/cache/330.html).

Alternatively it is common to simply use dropbox.

## Installed Packages

Currently there are a number of installed packages on Argo. They are stable versions of code and should not be changed. If you want to have your own version of some of the packages please install that in its own directory.

All the packages are installed in `/unsafe1/opt` and their source for a package can be found in `/unsafe1/opt/dev`. They include

### Core Packages
* sublime_text_3
* cmake
* python_packages
* OpenBLAS
* google drive
* spack (package manager)


### Astronomy/Cosmology related Packages
* wsclean-1.11
* casa-release-4.6.0-el6
* casacore
* karma (kvis)
* cfitsio
* wcslib
* Healpix_3.30

### McEwen et al Packages
* sopt
* s2let
* so3
* ssht

## Python packages

As mentioned above we have a virtual environment to allow us to install python packages without root acces. You can use these  if you include the relavant lines in the `.bashrc` file in the [Setting Up Your Environment](#environment) section. This will give you access to the installed packages and allow you to install any new packages you may want using `pip`. If you are new to `pip` check it out [here](https://packaging.python.org/en/latest/installing/). But all you really need to know is how to install a package, which you do by

{{< highlight bash >}}
pip install <package_name>
{{< / highlight >}}

and how to view installed packages

{{< highlight bash >}}
pip freeze
{{< / highlight >}}

## Specs

Argo was bought to allow people to run code that require an increased amount of cores or memory than available on a laptop. Below are the specs.

* 2 x 12 core 1.8GHz processors with 30MB cache memory
* 16 x 16GB RAM
* 4 x 3TB Hard drives (raided)
* GPU (NVIDIA Quadro K4200) 4GB memory
