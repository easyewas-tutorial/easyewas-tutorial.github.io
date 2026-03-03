# EWAS Model Computation Utilities

Model fitting functions for EWAS analysis using linear, mixed, or Cox
models. These are designed to be used inside parallel loops with minimal
memory footprint.

## Usage

``` r
ewasfun_lm(cg, ff, cov, facnum)

ewasfun_lmer(cg, ff, cov, facnum)

ewasfun_cox(cg, ff, cov)
```

## Arguments

- cg:

  A row vector representing one CpG site's beta values across samples.

- ff:

  A model formula object (e.g., cpg ~ var1 + var2).

- cov:

  A data.frame containing the covariates for the model.

- facnum:

  (Only for lm/lmer) Number of factor levels for exposure variable.

## Value

A numeric vector with model coefficients, standard errors, and p-values.
