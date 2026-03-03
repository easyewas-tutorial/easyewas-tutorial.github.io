# easyEWAS Troubleshooting Guide

This guide provides a practical error index for `easyEWAS`.


## 1. Installation and dependency issues

``` r

install.packages(c("remotes", "BiocManager"))
BiocManager::install(c("sva", "clusterProfiler", "org.Hs.eg.db", "DMRcate"))
remotes::install_github("ytwangZero/easyEWAS")
```


## 2. Data format and alignment issues

Rules:

- `ExpoData` first column: sample IDs
- `MethyData` first column: probe IDs
- `MethyData` sample columns must match `ExpoData` sample IDs


## 3. ComBat fails with prior plot

Try:

- `plot = FALSE`
- check NA patterns
- verify each batch has enough samples


## 4. DMR issues

Required genome/chip combinations:

- `EPICV2` + `hg38`
- `EPICV1` / `450K` + `hg19`
