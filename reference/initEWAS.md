# Initialize the EWAS module

This function generates an R6 class for storing EWAS analysis data and
results. By default, results are kept in memory and no files are
written. If file export is requested, users must supply an explicit
output directory.

## Usage

``` r
initEWAS(outpath = NULL, export = FALSE)
```

## Arguments

- outpath:

  Optional path to an existing directory. When `export = TRUE`, a
  subdirectory named `"EWASresult"` is created under `outpath` for
  exported result files.

- export:

  Logical. If `TRUE`, create an output folder and export result files.
  If `FALSE` (default), do not write files to disk; keep results in the
  returned object.

## Value

input, an R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(export = FALSE)
} # }
```
