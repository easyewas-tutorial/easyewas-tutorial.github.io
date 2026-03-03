# easyEWAS Quickstart

This tutorial shows a minimal end-to-end workflow for `easyEWAS`.

## 1. Install

``` r

install.packages(c("remotes", "BiocManager"))
remotes::install_github("ytwangZero/easyEWAS")
```

## 2. Load package

``` r

library(easyEWAS)
```

## 3. Download chip annotation once

[`startEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/startEWAS.md)
needs chip annotation data. Download and cache it before analysis.

``` r

downloadAnnotEWAS(chipType = "EPICV2") # also "EPICV1" or others.
```



## 4. Run a minimal EWAS workflow

``` r

res <- initEWAS(outpath = "default")

data("sampledata", package = "easyEWAS")
data("methydata", package = "easyEWAS")

res <- loadEWAS(
  input = res,
  ExpoData = sampledata,
  MethyData = methydata
)

res <- transEWAS(
  input = res,
  Vars = "cov1",
  TypeTo = "factor"
)

res <- startEWAS(
  input = res,
  model = "lm",
  expo = "var",
  cov = "cov1,cov2",
  chipType = "EPICV2"
)
```

## 5. Make plots

``` r

res <- plotEWAS(
  input = res,
  p = "PVAL",
  threshold = 0.05,
  file = "jpg"
)
```

## 6. Optional downstream analyses

``` r

res <- bootEWAS(
  input = res,
  filterP = "PVAL",
  cutoff = 0.001,
  times = 100
)

res <- enrichEWAS(
  input = res,
  method = "GO",
  filterP = "PVAL",
  cutoff = 0.05
)
```

For DMR analysis, install `DMRcate` first:

``` r

BiocManager::install("DMRcate")

res <- dmrEWAS(
  input = res,
  chipType = "EPICV2",
  what = "Beta",
  expo = "var",
  cov = "cov1,cov2",
  genome = "hg38"
)
```

## 7. Output files

All outputs are written to the folder created by
[`initEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/initEWAS.md),
by default:

- `EWASresult/ewasresult.csv`
- Plot files from
  [`plotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/plotEWAS.md)
- Optional downstream result files (`bootresult.csv`,
  `enrichresult.csv`, `DMRresult.csv`)
