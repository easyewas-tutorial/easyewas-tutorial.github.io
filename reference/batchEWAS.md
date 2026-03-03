# Perform batch effect correction

Perform batch effect correction based on the function
[`ComBat`](https://rdrr.io/pkg/sva/man/ComBat.html) form R package sva.
It requires that the "batches" in the data set are known. It uses either
parametric or non-parametric empirical Bayes frameworks for adjusting
data for batch effects.

## Usage

``` r
batchEWAS(
  input,
  adjustVar = NULL,
  batch = NULL,
  plot = FALSE,
  par.prior = TRUE,
  mean.only = FALSE,
  ref.batch = NULL,
  parallel = FALSE,
  core = NULL
)
```

## Arguments

- input:

  An R6 class integrated with all the information.

- adjustVar:

  (Optional) Names of the variate of interest and other covariates
  besides batch, with each name separated by a comma. Ensure that when
  correcting for batch effects, the effects of other factors are
  appropriately considered and adjusted for.Ensure there are no space.
  e.g. "cov1,cov2".

- batch:

  Name of the batch variable.

- plot:

  Logical. TRUE give prior plots with black as a kernel estimate of the
  empirical batch effect density and red as the parametric. Thr default
  is FALSE.

- par.prior:

  Logical. TRUE indicates parametric adjustments will be used, FALSE
  indicates non-parametric adjustments will be used.

- mean.only:

  Logical. Default to FALSE. If TRUE, ComBat only corrects the mean of
  the batch effect (no scale adjustment).

- ref.batch:

  (Optional) NULL If given, will use the selected batch as a reference
  for batch adjustment.

- parallel:

  Logical. Whether to enable parallel computing during batch effect
  correction. Default is `FALSE`.

- core:

  Integer. Number of CPU cores to use if `parallel = TRUE`. Default is
  `NULL`.

## Value

input, An R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
res <- loadEWAS(input = res, ExpoData = "default", MethyData = "default")
res <- transEWAS(input = res, Vars = "cov1", TypeTo = "factor")
res <- batchEWAS(input = res, batch = "batch", par.prior=TRUE, ref.batch = NULL)
} # }
```
