# Geomathematics-MatLab-code

## Introduction

This repository contains five of my most used MatLab scripts that help in processing and visualizing the most common data sets used in the Geomathematics Lab at CU.
More specifically, these scripts help with analysis of ICESat-2 ATL03 altimeter data and LandSat imagery. Supplemental scripts for the main code pieces are also included with **`fig.m`** used to format all the plots that are generated.
Look at the comments in the header of each code for information on how to run and the inputs required for each script.

## Code

**`atl03_track.m`**
Code that plots ICESat-2 tracks from the h5-file over an image of a specified glacier. There is an option to print the delta time’s to determine start and end times for dda runs. All additional scripts with the prefix 'plot' are used as helper scripts for this main script.
<br></br>

**`dataOnGLacier.m`**
Code that subsets a dataset to get only the data on a specified glacier, i.e., data within some contour specifying the glacier boundary.
<br></br>

**`landsat_show_bands.m`**
Code that displays a full resolution Landsat geotiff image with geolocated pixels. Useful for identifying glacier features and determining DDA-data locations.
<br></br>

**`icesat2_track_segs.m`**
Code that plots the location of the track segments given by the DDA over an image of the glacier (only works for Negribreen as of now, but it is easy to add additional glaciers).
<br></br>

**`ll2utm.m`**, **`utm211.m`**, **`polarstereo fwd.m`** and **`polarstereo inv.m`**
Code(s) that convert lat/lon to and from UTM coordinates, and to and from polar-stereographic coordinates.
<br></br>
