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
ee_Initialize(email = 'shreenapyakurel@gmail.com')
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
  bands = c("B5", "B4", "B3"),
  min = 5000, max = 15000, gamma = 1.3
)

Map$addLayer(image, vizParams, "Landsat 8 True color Composite")

```

Part 2: Night lights
``` r
createTimeBand <-function(img) {
  year <- ee$Date(img$get('system:time_start'))$get('year')$subtract(1991L)
  ee$Image(year)$byte()$addBands(img)
}
```

Compute a linear fit over the series of values at each pixel, visualizing the y-intercept in green, and positive/negative slopes as red/blue.

``` r
col_reduce <- collection$reduce(ee$Reducer$linearFit())
col_reduce <- col_reduce$addBands(
  col_reduce$select('scale'))
ee_print(col_reduce)
```

Create a interactive visualization\! 

``` r
Map$setCenter(9.08203, 47.39835, 3)
Map$addLayer(
  eeObject = col_reduce,
  visParams = list(
    bands = c("scale", "offset", "scale"),
    min = 0,
    max = c(0.18, 20, -0.18)
  ),
  name = "stable lights trend"
)

```
