# OPT3MAL

This directory contains code to predict mean annual air temperatures (MAAT) and pH from the relative abundances of 3-hydroxy fatty acids using a machine learning approach as described in:

*Global calibration of novel 3-hydroxy fatty acid based temperature and pH proxies\
Canfa Wang, James A. Bendle, Huan Yang, Yi Yang, Alice Hardman, Afrifa Yamoah, Amy Thorpe, Ilya Mandel, Sarah E. Greene, Junhua Huang, and Shucheng Xie\
Climate of the Past Discussions.*\
[doi:xxxxxx](https://doi.org/xxxxx)

The model with its built-in nearest neighbour distance screening is termed 'OPT3MAL' - Optimised Ph and Temperature predictions from 3-hydroxy-fatty-acids via MAchine Learning. See manuscript for further details.

## Getting Started

This repository contains all of the code and files you will need to run OPT3MAL. Start by downloading or cloning this repository in its entirety. The contents are as follows:

**README.md**: The readme you are currently reading.\
**OPT3MAL.m**: Calculates Nearest Neighbour Distances, MAAT, and pH using the GPR model.\
**3_OH_FA_CalibrationData.csv**: Modern calibration dataset (Wang et al., 2020; as above).\
**OPT3MAL_Demo.csv**: Demo 3-OH-FA dataset.\

## Prerequisites

Running the GPR model will require MATLAB (back compatible to version 2015b). 

* [MATLAB](https://mathworks.com/products/matlab.html)


## Running the model

To run the GPR model on the demo dataset, simply open and run OPT3MAL.m. This will load the provided modern calibration dataset: 

```
ModernCalibration.csv
```

and the provided demo dataset:

```
demo.csv
```
and will return:

1) A new csv file containing the 3-OH-FA data from the demo dataset, the nearest neighbour distances to the modern calibration dataset for both MAAT and pH, predicted MAAT, predicted pH, and 1 standard deviation on both the MAAT and pH predictions (error is Gaussian).
2) A plot of the predicted MAAT error (1 standard deviation) vs. the nearest neighbour distances for the demo dataset.
3) A plot of the predicted pH error (1 standard deviation) vs. the nearest neighbour distances for the demo dataset.
4) A plot of the predicted MAAT with error bars (1 standard deviation) vs. sample number. Samples failing the nearest neighbour screening (>0.5) are plotted in grey; samples passing the screening test are coloured according to their nearest neighbour distance.
5) A plot of the predicted pH with error bars (1 standard deviation) vs. sample number. Samples failing the nearest neighbour screening (>0.5) are plotted in grey; samples passing the screening test are coloured according to their nearest neighbour distance.

To predict MAAT and pH from a new dataset, format your 3-OH-FA fractional abundance dataset using the demo dataset as a guide and save it as a csv file in the same directory. Then open OPT3MAL.m, change the filename loaded in line XXXXXXXX, set your desired output file names in lines XXXXXX, and run the script.

NOTE: Be advised that OPT3MAL will make MAAT and pH predictions for samples with contraindicative Nearest Neighbour Distances; these samples should be screened out before publishing.

## Publishing outputs from this code

Publications using this code should cite Wang et al., 2020. In addition, the following data are required to ensure your work is reproducible:
1) Full relative abundance data for all 3-OH-FA compounds
2) Citation of modern calibration dataset used
3) Publication of full calibration dataset if it has not been previously published elsewhere

## Authors

* Ilya Mandel
* Sarah Greene
