---
author: Jennifer Chan
categories:
- tutorials
date: "2015-08-10T00:00:00Z"
draft: true
image: images/posts/2015-08-10-Configuring-Matlab-MEX-Compiler/configuration_mario.jpeg
tags:
- computing
- code installation
title: Configuring Matlab MEX’s Compiler
---

A short note about configuring MATLAB MEX's compiler as GCC (MATLAB version: R2014a ; MacOSX: 10.9(.5)):
<!--more-->

![configuration_mario](/images/posts/2015-08-10-Configuring-Matlab-MEX-Compiler/configuration_mario.jpeg)

1.	Open MATLAB
2.	At the MATLAB command prompt, run `mex -setup` and select fortran on the list :
    ```bash
	>> mex -setup FORTRAN
	>> Error using mex No supported compiler or SDK was found. For options, visit http://www.mathworks.com/support/compilers/R2014a/maci64.
    ```
3.	`cd (matlabroot)`
4.	`cd bin`
5.	Save a copy of `mexopts.sh` as `ORIGINAL_mexopts.sh`
6.	In the file of `mexopts.sh`, replace all instances (five) of MacOSX10.7 by MacOSX10.9 in the `maci64` section
7.	At the MATLAB terminal, run
    ```bash
    mex -setup
    ```
8.	Choose the `altered mexopts.sh` (option 2).


