---
author: Tarek Allam
categories:
- tutorials
image: images/posts/2018-07-05-Cadence-Wars/LSSTcadence.png
draft: true
date: Thu Jul  5 15:01:14 BST 2018
tags:
- programming
- unix
- cloud
title: Settling The Cadence Wars - Introduction
mathjax : true
---

*Science Driven Optimisation of the LSST Observing Stratergy*

<!--more-->

<img src="/images/posts/2018-07-05-Cadence-Wars/LSST-render.png" style="float: right;margin: 0px 0px 15px 20px;">

# Science Driven Optimisation of the LSST Observing Strategy

# Table of contents
1. [A Little Bit About the LSST](#introduction)
2. [Science Case Questions](#questions)
3. [The Operations Simulator and its Outputs](#opsim)
4. [Transient Supernova](#trans)
5. [Supernova Cosmology](#cosmo)
6. [LSST + WFIRST](#wfirst)
7. [Initial White Paper Conclusions](#conclusion)


<a name="introduction"></a>
## A Little Bit About the LSST

The Large Synoptic Survey Telescope (LSST) is a dedicated optical telescope with
an effective aperture of 6.7 meters, currently under construction on
[Cerro Pach´on](https://en.wikipedia.org/wiki/Cerro_Pach%C3%B3n)
in the Chilean Andes. The mantra of Wide-Fast-Deep, i.e., the ability to cover large
swaths of sky ("Wide") to faint magnitudes ("Deep") in a short amount of time
("Fast"), allowing it to scan the sky repeatedly. LSST will image in six broad
filters, _ugrizy_, spanning the optical band from the atmospheric cutoff in the
ultraviolet to the limit of CCD sensitivity in the near-infrared.

Of the major science cases, the one that most interests my work are:

* Exploring the transient and variable universe.
* Probing the distribution of dark matter and measuring the effects of dark
energy (via measurements of gravitational lensing, satellite galaxies and
streams, large-scale structure, clusters of galaxies, and **supernovae**).

To zeroth order, the LSST
allows it to meet all its science goals with a single dataset with a "universal"
cadence. However, small perturbations to such a universal strategy are expected
to yield significant improvements to certain science investigations. The
document found [here](https://arxiv.org/pdf/1708.04058.pdf)
describes the design of the current "baseline" LSST cadence, and
various ways in which it could be further refined to optimize the overall
science output of the survey. In order to quantify the
effectiveness of a given cadence realisation to meet science goals a
series of quantitative metrics needed to be defined. Any given realisation will be more favorable for
some science areas, and less so for others; the metrics allow one to quantify
this, and this optimise the overall cadence for the broadest range of LSST science
areas.

The _baseline_ cadence is a specific realisation of the OpSim output, which meets
the LSST survey requirements. This cadence is designed to give uniform coverage at
any given time, and reaches the survey goals for measuring stellar parallax and
proper motion over the ten-year survey. The survey requirements on depth lead to
roughly 825 visits (summing over the six filters) in the 10-year LSST survey to
any given point on the sky. While the baseline cadence demonstrates that the
LSST is capable of meeting its stated science goals, it is not optimized for all
science.

<a name="questions"></a>
## Science Case Questions

**Q1** _Does the science case place any constraints on the
tradeoff between the sky coverage and coadded depth? For example, should
the sky coverage be maximized (to $\sim$30,000 deg$^2$, as e.g., in
Pan-STARRS) or the number of detected galaxies (the current baseline of 18,000
deg$^2$)?_

**Q2** _Does the science case place any constraints on the
tradeoff between uniformity of sampling and frequency of  sampling? For
example, a rolling cadence can provide enhanced sample rates over a part
of the survey or the entire survey for a designated time at the cost of
reduced sample rate the rest of the time (while maintaining the nominal
total visit counts)_

**Q3** _Does the science case place any constraints on the
tradeoff between the single-visit depth and the number of visits
(especially in the $u$-band where longer exposures would minimize the
impact of the readout noise)?_

**Q4** _Does the science case place any constraints on the
Galactic plane coverage (spatial coverage, temporal sampling, visits per
band)?_

**Q5** _Does the science case place any constraints on the
fraction of observing time allocated to each band?_

**Q6** _Does the science case place any constraints on the
cadence for deep drilling fields?_

**Q7** _Assuming two visits per night, would the science case
benefit if they are obtained in the same band or not?_

**Q8** _Will the case science benefit from a special cadence
prescription during commissioning or early in the survey, such as:
acquiring a full 10-year count of visits for a small area (either in all
the bands or in a  selected set); a greatly enhanced cadence for a small
area?_

**Q9** _Does the science case place any constraints on the
sampling of observing conditions (e.g., seeing, dark sky, airmass),
possibly as a function of band, etc.?_

**Q10** _Does the case have science drivers that would require
real-time exposure time optimization to obtain nearly constant
single-visit limiting depth?_

" _what we are really trying to do is minimize global unhappiness with the
LSST observing strategy._ " -- **Phil Marshall**

<a name="opsim"></a>
## OpSim and its Outpus

OpSim is a software tool that runs a survey simulation with given science driven
desirables; a soft- ware model of the telescope and its control system; and
models of weather and other environmental variables. The output of such a
simulation is an “observation history,” which is a record of times, pointings
and associated environmental data and telescope activities throughout the
simulated survey. This history can be examined to assess whether the simulated
survey would be useful for any particular purpose or interest.

**Wide, Fast, Deep (WFD)**: The WFD is the primary LSST survey, taking 85-95% of the
observing time and covering 18,000 square degrees of sky, in the current
implementation
spanning the declination range from about −65 to about +5 degrees (the total sky
area between these limits is about 20,500 square degrees, but a region aligned
with the Galactic
Plane is not included in WFD). This observing proposal is usually configured to
attempt 26
2.3 The Baseline Observing Strategy
observing pairs spaced ∼ 40 minutes apart. This temporal spacing is designed to
optimize the detection of moving solar system objects. This proposal typically
balances the six ugrizy
filters, observing each field every ∼ 3 days.

**Deep Drilling Fields (DD)**: The Deep Drilling Fields are single pointings that
are observed in extended sequences. The DD proposals often include certain
filter combinations to ensure
that near-simultaneous color information is available for variable and transient
objects. Four of the LSST Deep Drilling fields have been selected and announced.
It is expected that there will be more DD fields selected for the final survey.
Most of the simulations here include five DD fields.

One of the more unique constraints on the OpSim scheduler is that it highly
penalizes, and thus avoids, filter changes. With it’s large field of view, LSST
filter changes take about two minutes to complete. The filters are also large
and heavy enough that we want to minimize wear on the filter changing mechanism.

### The Baseline Observing Strategy

The official (managed by the LSST Change Control Board) Baseline Cadence, minion
1016, was produced by the 3.3.5 version of OpSim. The Baseline Cadence is
introduced first then analysis of other simulautions that
modify the baseline observing strategy in various informative ways.

#### minion 1016

The Baseline Cadence, minion 1016, has the following basic properties:

### Rolling Cadence

With a total of ∼ 800 visits spaced approximately uniformly over 10 years, and
distributed among 6 filters, it is not clear that LSST can offer the
sufficiently dense sampling in time for study of
transients with typical durations less than or  1week. This is particularly a
concern for key science requiring well-sampled SNIa light curves. “Rolling”
cadences stand out as a general solution that
can potentially enhance sampling rates by 2× or more, on some of the sky all of
the time and all of the sky some of the time, while maintaining a sufficient
uniformity for survey objectives that
require it.

