# Perform EWAS Analysis

Perform EWAS analysis to obtain the coefficient value, standard
deviation and significance p value (or adjust p value) of each site.

## Usage

``` r
startEWAS(
  input,
  filename = "default",
  model = "lm",
  expo = NULL,
  cov = NULL,
  random = NULL,
  time = NULL,
  status = NULL,
  adjustP = TRUE,
  chipType = "EPICV2",
  core = "default",
  annotation_cache = NULL,
  auto_download_annotation = FALSE,
  annotation_base_url = getOption("easyEWAS.annotation_base_url",
    "https://github.com/ytwangZero/easyEWAS_materials/raw/main/annotation")
)
```

## Arguments

- input:

  An R6 class integrated with all the information obtained from the
  loadEWAS or transEWAS function.

- filename:

  filename Name of the output CSV file to store EWAS results. If set to
  "default", the file will be named "ewasresult.csv" and saved in the
  specified output directory.

- model:

  Statistical model to use for EWAS analysis. Options include:

  - "lm": Linear regression (default)

  - "lmer": Linear mixed-effects model

  - "cox": Cox proportional hazards model

- expo:

  Name of the exposure variable used in the EWAS analysis.

- cov:

  Comma-separated list of covariate variable names to include in the
  model (e.g., "age,sex,bmi"). Do not include spaces between names.
  Optional.

- random:

  Name of the grouping variable for the random intercept, required only
  when using the "lmer" model.

- time:

  Name of the time-to-event variable, required only when using the "cox"
  model.

- status:

  Name of the event/censoring indicator variable, required only when
  using the "cox" model.

- adjustP:

  Logical. If TRUE (default), adjusts p-values using both FDR
  (Benjamini-Hochberg) and Bonferroni correction methods.

- chipType:

  Illumina array platform used for DNA methylation measurement.
  Available options:

  - "27K"

  - "450K"

  - "EPICV1"

  - "EPICV2" (default)

  - "MSA"

- core:

  Number of CPU cores to use for parallel processing. If set to
  "default", uses the number of available physical cores minus one.

- annotation_cache:

  Local directory for cached annotation files. If NULL, uses
  `tools::R_user_dir("easyEWAS", "cache")/annotation`.

- auto_download_annotation:

  Logical. If TRUE, annotation files are downloaded automatically when
  missing.

- annotation_base_url:

  Base URL for annotation `.rds` files.

## Value

input, An R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
res <- loadEWAS(input = res, ExpoData = "default", MethyData = "default")
res <- transEWAS(input = res, Vars = "cov1", TypeTo = "factor")
downloadAnnotEWAS(chipType = "EPICV2")
res <- startEWAS(input = res, filename = "default", chipType = "EPICV2", model = "lm",
expo = "var", cov = "cov1,cov2",adjustP = TRUE, core = "default")
} # }
```
