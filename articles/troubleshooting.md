# easyEWAS Troubleshooting Guide

This guide provides a practical error index for `easyEWAS`.

## 1. Quick diagnostics

``` r

sessionInfo()
packageVersion("easyEWAS")
str(res$Data$Expo)
str(res$Data$Methy)
```

## 2. Installation and dependency issues

### 2.1 Missing package errors

``` r

install.packages(c("remotes", "BiocManager"))
BiocManager::install(c("sva", "clusterProfiler", "org.Hs.eg.db", "DMRcate"))
remotes::install_github("ytwangZero/easyEWAS")
```

### 2.2 `dmrEWAS()` asks for `DMRcate`

``` r

BiocManager::install("DMRcate")
```

## 3. Annotation download and caching issues

### 3.1 Annotation missing in cache

``` r

downloadAnnotEWAS(chipType = "EPICV2")
```

### 3.2 Custom annotation source

``` r

options(easyEWAS.annotation_base_url = "https://your-server/path/to/annotation")
downloadAnnotEWAS(chipType = "EPICV2")
```

## 4. Data format and alignment issues

Rules:

- `ExpoData` first column: sample IDs
- `MethyData` first column: probe IDs
- `MethyData` sample columns must match `ExpoData` sample IDs

## 5. Model setup issues

### 5.1 Invalid model type

Use only:

- `"lm"`
- `"lmer"`
- `"cox"`

### 5.2 Cox status is factor

Convert to numeric:

``` r

res$Data$Expo$status <- as.numeric(as.character(res$Data$Expo$status))
```

### 5.3 Exposure should be factor

``` r

res <- transEWAS(res, Vars = "var", TypeTo = "factor")
```

## 6. Batch correction issues

### 6.1 Batch variable not found

``` r

colnames(res$Data$Expo)
```

### 6.2 ComBat fails with prior plot

Try:

- `plot = FALSE`
- check NA patterns
- verify each batch has enough samples

## 7. Plotting issues

### 7.1 No EWAS result found

Run
[`startEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/startEWAS.md)
before
[`plotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/plotEWAS.md).

### 7.2 P-value column not found

``` r

colnames(res$result)
```

## 8. Bootstrap/enrichment issues

### 8.1 No significant CpGs

Relax cutoff:

``` r

res <- bootEWAS(res, filterP = "PVAL", cutoff = 0.01, times = 100)
```

### 8.2 Empty enrichment output

Check significance threshold and gene mapping quality.

## 9. DMR issues

Recommended genome/chip combinations:

- `EPICV2` + `hg38`
- `EPICV1` / `450K` + `hg19`
