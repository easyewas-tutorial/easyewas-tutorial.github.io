# easyEWAS

[![R](https://img.shields.io/badge/R-%3E%3D%204.2-blue)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](#)
[![GitHub Repo](https://img.shields.io/badge/GitHub-ytwangZero%2FeasyEWAS-black?logo=github)](#)
[![Last updated](https://img.shields.io/badge/Last%20updated-2026--03--03-informational)](#)

<p><small><i class="fa-regular fa-user"></i> Author: Yuting Wang, Xu Gao (Corresponding)</small></p>

easyEWAS is an R package for conducting Epigenome-Wide Association Study (EWAS) 
in a unified and reproducible way. It supports Illumina methylation array platforms 
including 27K,450K, EPIC v1, EPIC v2, and MSA, and provides an end-to-end workflow
covering association modeling, batch-effect handling, result
visualization, bootstrap-based internal validation, enrichment analysis,
and optional DMR discovery.

## <i class="fa-solid fa-circle-exclamation"></i> Download Annotation by Chip Type (Must Read)

<div class="alert alert-warning" role="alert">
<i class="fa-solid fa-triangle-exclamation"></i>
<strong>Update (March 3, 2026):</strong> chip annotation is no longer bundled in the main package tarball.
Please download annotation for your chip(s) before running <code>startEWAS()</code> or <code>dmrEWAS()</code>.
</div>

### Supported `chipType` Values

- `27K` — Infinium HumanMethylation27 BeadChip  
- `450K` — Infinium HumanMethylation450 BeadChip  
- `EPICV1` — Infinium MethylationEPIC BeadChip (v1.0)  
- `EPICV2` — Infinium MethylationEPIC BeadChip (v2.0)  
- `MSA` — Infinium Methylation Screening Array  

### Function Signature

``` r
downloadAnnotEWAS(
  chipType = c("EPICV2", "EPICV1", "450K", "27K", "MSA"),
  cache_dir = NULL,
  force = FALSE,
  base_url = getOption(
    "easyEWAS.annotation_base_url",
    "https://github.com/ytwangZero/easyEWAS_materials/raw/main/annotation"
  ),
  quiet = FALSE
)
```

### Parameter Guide

| Parameter | What to fill | Example |
|:--|:--|:--|
| `chipType` | Required. One or more chip types to download. | `"EPICV2"` or `c("EPICV2","450K")` |
| `cache_dir` | Optional. Custom local folder for annotation cache. | `"/path/to/annotation_cache"` |
| `force` | Optional. Re-download and overwrite existing cache. | `TRUE` |
| `base_url` | Optional. Annotation source URL. | official GitHub-hosted materials |
| `quiet` | Optional. Download verbosity passed to `utils::download.file()`. | `FALSE` |

### Common Usage Examples

``` r
# 1) Download one chip annotation (most common)
downloadAnnotEWAS(chipType = "EPICV2")

# 2) Download multiple chips at once
downloadAnnotEWAS(chipType = c("EPICV2", "450K"))

# 3) Force refresh existing cache files
downloadAnnotEWAS(chipType = "EPICV2", force = TRUE)

# 4) Use a custom cache folder
downloadAnnotEWAS(chipType = "EPICV2", cache_dir = "/path/to/annotation_cache")
```

<div class="alert alert-info" role="alert">
<i class="fa-solid fa-lightbulb"></i>
<strong>Tip:</strong> keep <code>chipType</code> consistent across <code>downloadAnnotEWAS()</code>, <code>startEWAS()</code>, and <code>dmrEWAS()</code>.
</div>

## <i class="fa-solid fa-sliders"></i> Installation

Before installing `easyEWAS`, we recommend pre-installing optional
dependencies used by advanced modules.

### Core dependencies by function

| Function | Required packages | Notes |
|:--|:--|:--|
| `batchEWAS()` | `sva` | Required for ComBat batch correction |
| `batchEWAS(..., parallel = TRUE)` | `sva`, `BiocParallel` | `BiocParallel` is needed only for parallel mode |
| `enrichEWAS()` | `clusterProfiler`, `org.Hs.eg.db` | Required for ID conversion and GO/KEGG enrichment |
| `enrichEWAS(plot = TRUE, plotType = "dot")` | `enrichplot` | Required for dotplot visualization |
| `dmrEWAS()` | `DMRcate` | Required for DMR analysis |

### Recommended pre-install

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install(
  c(
    "sva",
    "BiocParallel",
    "clusterProfiler",
    "org.Hs.eg.db",
    "enrichplot",
    "DMRcate"
  ),
  ask = FALSE,
  update = TRUE
)
```

### Install from GitHub

``` r
remotes::install_github("ytwangZero/easyEWAS")
```

### Load package:

``` r
library(easyEWAS)
```

If you prefer installing only when needed:

- `batchEWAS()`: `BiocManager::install(c("sva", "BiocParallel"))`
- `enrichEWAS()`: `BiocManager::install(c("clusterProfiler", "org.Hs.eg.db", "enrichplot"))`
- `dmrEWAS()`: `BiocManager::install("DMRcate")`


## <i class="fa-solid fa-quote-left"></i> Citation

Wang Y, Jiang M, Niu S, Gao X. easyEWAS: a flexible and user-friendly R
package for epigenome-wide association study\[J\]. Bioinformatics
Advances, 2025, 5(1): vbaf026.
