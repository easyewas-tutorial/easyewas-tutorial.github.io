# easyEWAS Quickstart

This tutorial shows a minimal end-to-end workflow for `easyEWAS`.


## <i class="fa-solid fa-circle-exclamation" style="color:#d9534f;"></i> Download Annotation by Chip Type (Must Read)

<div class="alert alert-warning" role="alert">
<i class="fa-solid fa-triangle-exclamation"></i>
<strong>Update (March 3, 2026):</strong> chip annotation is no longer bundled in the main package tarball.
Please download annotation for your chip(s) before running <code>startEWAS()</code> or <code>dmrEWAS()</code>.
</div>

Supported `chipType` values:

- `27K` — Infinium HumanMethylation27 BeadChip
- `450K` — Infinium HumanMethylation450 BeadChip
- `EPICV1` — Infinium MethylationEPIC BeadChip (v1.0)
- `EPICV2` — Infinium MethylationEPIC BeadChip (v2.0)
- `MSA` — Infinium Methylation Screening Array

Function signature:

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

Common usage examples:

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



## 1. Run a minimal EWAS workflow

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

## 2. Optional downstream analyses

``` r

res <- plotEWAS(
  input = res,
  p = "PVAL",
  threshold = 0.05,
  file = "jpg"
)
```

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

## 3. Output files

All outputs are written to the folder created by
[`initEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/initEWAS.md),
by default:

- `EWASresult/ewasresult.csv`
- Plot files from
  [`plotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/plotEWAS.md)
- Optional downstream result files (`bootresult.csv`,
  `enrichresult.csv`, `DMRresult.csv`)
