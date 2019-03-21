---
author: Tarek Allam
categories:
- tutorials
image: images/posts/2018-08-06-AstroInfo-Glossary/dictionary-day-fun.jpg
date: ""
tags:
- programming
- unix
- cloud
title: Astroinformatics Glossary
---

*Astroinformatics Jargon Explained*

<!--more-->

# Glossary

<img src="https://imgs.xkcd.com/comics/period_speech.png" style="float: 0px 0px 10px 15px;">

## Dithering

A description of how the data is dithered (or jittered)
It is common practice to split a long NIR exposure into several short exposures
at slightly different positions in order to minimize the contribution from bad
pixels and cosmic rays and to avoid background saturation. Dithering shifts and
combines these input frames into a single output using the appropriate dither
offsets.
These dither offsets are initially calculated from the WCS parameters in the
FITS headers that have been generated from the astrometric calibration. The
offsets are then further refined by object position cross-correlation.

Note that the offsets are always whole pixels so no resampling is required.

## Airmass

In astronomy, air mass (airmass, or AM) is the path length for light from a
celestial source to pass through the atmosphere. As it penetrates the
atmosphere, light is attenuated by scattering and absorption; the thicker
atmosphere through which it passes, the greater the attenuation. Consequently,
celestial bodies at the horizon appear less bright than when at the zenith. The
attenuation, known as atmospheric extinction, is described quantitatively by the
Beer–Lambert–Bouguer law.

“Air mass” normally indicates relative air mass, the path length relative to
that at the zenith at sea level so, by definition, the sea-level air mass at the
zenith is 1. Air mass increases as the angle between the source and the zenith
increases, reaching a value of approximately 38 at the horizon. Air mass can be
less than one at an elevation greater than sea level; however, most closed-form
expressions for air mass do not include the effects of elevation, so adjustment
must usually be accomplished by other means.

[wiki](https://en.wikipedia.org/wiki/Air_mass_(astronomy))

## Malmquist

## Galactic Confusion Zone

AKA _Zone of Avoidance (ZOA)_ is the area of the sky that is obscured by the
Milky Way. From the galactic plane of the Milky Way, the Zone of Avoidance spans
roughly 10° on either side.

When viewing space from Earth, the attenuation, interstellar dust, and stars in
the plane of the Milky Way (the galactic plane) obstruct the view of around 20%
of the extragalactic sky at visible wavelengths. As a result, optical galaxy
catalogues are usually incomplete close to the galactic plane.

[wiki](https://en.wikipedia.org/wiki/Zone_of_Avoidance)

## Coadded

Coadding is not an especially precise term, I don't think, but in general it
just means stacking or combining images --- very literally, just
'adding-together'. I usually hear this in terms of stacking images of the same
field (e.g. of an optical image), but I think it can also be used to mean mosaic
images, even in arbitrary parameter spaces.
