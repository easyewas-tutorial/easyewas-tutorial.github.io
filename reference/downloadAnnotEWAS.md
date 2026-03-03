# Download and cache chip annotation tables

Download CpG annotation tables for supported Illumina chip types and
store them in a local cache directory. The downloaded files are saved as
`.rds` and reused in later analyses.

## Usage

``` r
downloadAnnotEWAS(chipType = c("EPICV2", "EPICV1", "450K", "27K", "MSA"),
cache_dir = NULL, force = FALSE, base_url = getOption("easyEWAS.annotation_base_url",
"https://github.com/ytwangZero/easyEWAS_materials/raw/main/annotation"), quiet = FALSE)
```

## Arguments

- chipType:

  One or more chip types. Supported values: `"EPICV2"`, `"EPICV1"`,
  `"450K"`, `"27K"`, and `"MSA"`.

- cache_dir:

  Directory to store downloaded annotation files. If `NULL`, the default
  cache path `tools::R_user_dir("easyEWAS", "cache")/annotation` is
  used.

- force:

  Logical. If `TRUE`, re-download and overwrite existing cached files.

- base_url:

  Base URL where annotation `.rds` files are hosted.

- quiet:

  Logical. Passed to
  [`utils::download.file()`](https://rdrr.io/r/utils/download.file.html).

## Value

A named character vector of local file paths (invisibly).
