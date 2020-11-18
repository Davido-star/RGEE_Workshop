---
title: "R Notebook"
authors: Miles Van Denburg and Shreena Pyakurel
output: html_notebook
---

Initiate Google Earth engine and load libraries  
```{r}
remotes::install_github("r-spatial/rgee", force = TRUE)
library(rgee)
library(sf)
library(tidyverse)
```

Install ee_install to get earth engine function 

```{r}
ee_install() #only need to run once
ee_Initialize(email = 'INSERT EMAIL')
```

if there is an error saying python environment is not available or something related run these 2 lines and repeat previous 2 lines
```{r}
ee_clean_pyenv()
 ee_clean_credentials()
```


Visualize a Landsat image collection in a true color composite 
```{r}
image <- ee$Image("LANDSAT/LC08/C01/T1/LC08_044034_20140318")
            
Map$centerObject(image)

vizParams <- list(
  bands = c("B4", "B3", "B2"),
  min = 5000, max = 15000, gamma = 1.3
)

Map$addLayer(image, vizParams, "Landsat 8 True color Composite")

```

Visualize night-time lights

Load dataset and calcutalte average 
```{r}
dataset  <- ee$ImageCollection('NOAA/DMSP-OLS/NIGHTTIME_LIGHTS')$filter(ee$Filter$date('2010-01-01', '2010-12-31'))

nighttimeLights <-  dataset$select('stable_lights')

data_reduce <- nighttimeLights$reduce(ee$Reducer$mean())

```


```{r}
nighttimeLightsVis <-  list(
  min =  3.0,
  max =  60.0
)

Map$setCenter(7.82, 49.1, 4)

Map$addLayer(data_reduce, nighttimeLightsVis, 'Nighttime Lights')


```

