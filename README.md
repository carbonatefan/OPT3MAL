# OPT3MAL

This directory contains code to predict mean annual air temperatures (MAAT) and pH from the relative abundances of 3-hydroxy fatty acids in soils using a machine learning approach as described in:

*Global calibration of novel 3-hydroxy fatty acid based temperature and pH proxies\
Canfa Wang, James A. Bendle, Huan Yang, Yi Yang, Alice Hardman, Afrifa Yamoah, Amy Thorpe, Ilya Mandel, Sarah E. Greene, Junhua Huang, and Shucheng Xie\
Geochimica et Cosmochimica Acta (in press)*\
[doi:xxxxxx](https://doi.org/xxxxx)

The model with its built-in nearest neighbour distance screening is termed '**OPT3MAL**' - **O**ptimised **P**H and **T**emperature predictions from **3**-hydroxy-fatty-acids via **MA**chine **L**earning. See manuscript for further details.

## Getting Started

This repository contains all of the code and files you will need to run OPT3MAL. Start by downloading or cloning this repository in its entirety. The contents are as follows:

**README.md**: The readme you are currently reading.\
**OPT3MAL.m**: Calculates Nearest Neighbour Distances, MAAT, and pH using the GPR model.\
**3_OH_FA_CalibrationData.csv**: Modern soil calibration dataset (Wang et al., 2021; as above).\
**OPT3MAL_Demo.csv**: Demo 3-OH-FA dataset.

## Prerequisites

Running the GPR model will require MATLAB (back compatible to version 2015b). 

* [MATLAB](https://mathworks.com/products/matlab.html)


## Running the model

To run the OPT3MAL on the demo dataset, simply open and run OPT3MAL.m. This will load the provided modern calibration dataset: 

```
3_OH_FA_CalibrationData.csv
```

and the provided demo dataset:

```
OPT3MAL_Demo.csv
```
and will return:

1) A new csv file containing the 3-OH-FA data from the demo dataset, the nearest neighbour distances to the modern calibration dataset for both MAAT and pH, predicted MAAT, predicted pH, and 1 standard deviation on both the MAAT and pH predictions (error is Gaussian).
2) A plot of the predicted MAAT error (1 standard deviation) vs. the nearest neighbour distances for the demo dataset.
3) A plot of the predicted pH error (1 standard deviation) vs. the nearest neighbour distances for the demo dataset.
4) A plot of the predicted MAAT with error bars (1 standard deviation) vs. sample number. Samples failing the nearest neighbour screening (>0.5) are plotted in grey; samples passing the screening test are coloured according to their nearest neighbour distance.
5) A plot of the predicted pH with error bars (1 standard deviation) vs. sample number. Samples failing the nearest neighbour screening (>0.5) are plotted in grey; samples passing the screening test are coloured according to their nearest neighbour distance.

## User notes 
1) To predict MAAT and pH from a new dataset using the global calibration provided in Wang et al., 2021, format your 3-OH-FA fractional abundance dataset using the demo dataset as a guide and save it as a csv file in the same directory. Then open OPT3MAL.m, change the filename loaded in line 35, set your desired output file names in lines 40-44, and run the script.
2) OPT3MAL will make MAAT and pH predictions for samples with contraindicative Nearest Neighbour Distances; we recommend these predictions be screened out before publishing. Nearest neighbour distances will differ in pH and MAAT space for the same sample, i.e. there may be samples for which a calibration dataset provides robust constraints for pH, but not for MAAT and vice versa. For further discussion of nearest neighbour distance screenings, see Dunkley Jones et al., 2020: OPTiMAL: A new machine learning approach for GDGT-based palaeothermometry, Climate of the Past, [doi:10.5194/cp-16-2599-2020](https://doi.org/10.5194/cp-16-2599-2020).
3)  As a default, OPT3MAL builds the GPR model using only the C15 and C17 3-OH-FA compounds. If you wish to make predictions using all compounds instead, change the setting in line 47 to 'true'.
4)  To use a different calibration dataset (e.g. a regional calibration or an expanded global dataset), format your calibration dataset using the calibration dataset provided as a guide and save it as a csv file in the same directory. Then open OPT3MAL.m and change the filename loaded in line 37.

## Publishing outputs from this code

Publications using this code should cite Wang et al., 2021. In addition, the following data are required to ensure your work is reproducible:
1) Full relative abundance data for all 3-OH-FA compounds
2) Citation of modern calibration dataset used OR
3) Publication of the full calibration dataset used, if it has not been previously published elsewhere

## Authors

* Ilya Mandel
* Sarah Greene
