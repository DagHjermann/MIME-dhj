---
title: "Correlations between fat and organics - Norwegian cod"
author: "DHJ"
date: "25 11 2020"
output: 
  html_document:
    toc: true
    toc_float: true
    keep_md: true
---










## Example: one substance (BDE49), one station (30B)    
  
Model: `ln(concentration) = a*ln(fat) + b*Length + spline(Year)`  

Thus:  

* The effect of ln(fat) assumed to be linear   
* Effect of year (non-linear effect) and length (linear) also taken into account   

In the output and plot below,  
* MYEAR = measurement year  
* FAT_PERC = fat percentage in tissue    
* LNMEA = length of fish in millimeters    


```
## 
## Family: gaussian 
## Link function: identity 
## 
## Formula:
## log(VALUE_WW) ~ s(MYEAR) + log(FAT_PERC) + LNMEA
## 
## Parametric coefficients:
##                 Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   -3.5859669  0.3950471  -9.077  < 2e-16 ***
## log(FAT_PERC)  1.1314555  0.1046854  10.808  < 2e-16 ***
## LNMEA          0.0015137  0.0005478   2.763  0.00626 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##            edf Ref.df     F p-value   
## s(MYEAR) 2.153  2.579 5.405 0.00326 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.447   Deviance explained = 45.8%
## GCV = 0.66053  Scale est. = 0.64401   n = 206
```

Plot of the model. The y axis is the expected w.w. concentration (given all aother variables are at mean value), and the x axes are    
  

![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


### Several substances + stations          



## Effect of fat, slope {.tabset}  

Effect of ln(fat) on ln(concentration)   

* Analysis on station-by-station basis   
* The effect of ln(fat) assumed to be linear   
* Effect of year (non-linear effct) and length (linear) also taken into account   
* Analysis done for time series with at least 10 years and at least 70% data over LOQ    
  
### PCBs
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-7-1.png)<!-- -->


### BDEs
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-8-1.png)<!-- -->



### Organochorines, paraffins
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-9-1.png)<!-- -->


### PFAS and DDTs
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

  
## Effect of fat, explained variance {.tabset}  
  
### PCBs
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

### BDEss
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


### Organochorines, paraffins
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


### PFAS and DDTs
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

## Some more examples  
  
In all figures, the y axis is the expected w.w. concentration (given all aother variables are at mean value), and the x axes are    
* MYEAR = measurement year  
* FAT_PERC = fat percentage in tissue    
* LNMEA = length of fish in millimeters   
  






### CB52 at station 36B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-17-1.png)<!-- -->





### CB118 at station 36B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-19-1.png)<!-- -->




### CB_S7 at station 36B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-21-1.png)<!-- -->




### BDE49 at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-23-1.png)<!-- -->




### BDE99 at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-25-1.png)<!-- -->




### BDE6S at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-27-1.png)<!-- -->




### OCS at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-29-1.png)<!-- -->





### HCB at station 23B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-31-1.png)<!-- -->





### SCCP at station 23B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-33-1.png)<!-- -->





### PFOS at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-35-1.png)<!-- -->





### DDEPP at station 30B      
![](07_Correlations_with_fat_cod_files/figure-html/unnamed-chunk-37-1.png)<!-- -->

