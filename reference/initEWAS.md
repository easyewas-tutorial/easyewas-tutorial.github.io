# Initialize the EWAS module

This function is designed to generate an R6 class for storing all the
data and results of EWAS analysis, and also to create a folder on the
local computer for storing the analysis results.

## Usage

``` r
initEWAS(outpath = "default")
```

## Arguments

- outpath:

  The user-specified path is used to store a generated folder named
  "EWASresult" that contains all the analysis results. If "default" is
  specified, the folder will be generated in the current working
  directory.

## Value

input, an R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
} # }
```
