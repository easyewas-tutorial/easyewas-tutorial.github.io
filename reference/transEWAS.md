# Convert variable type of sample data

Transform the variable types of sample data to the types specified by
users.

## Usage

``` r
transEWAS(input, Vars = "default", TypeTo = "factor")
```

## Arguments

- input:

  An R6 class integrated with all the information obtained from the
  loadEWAS function.

- Vars:

  Variable names that the user wants to convert types for, with each
  variable name separated by a comma. Ensure there are no spaces. e.g.
  "var1,var2,var3".

- TypeTo:

  The type of variable that the function allows to be converted,
  including numeric and factor.

## Value

input, An R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
res <- loadEWAS(input = res, ExpoData = "default", MethyData = "default")
res <- transEWAS(input = res, Vars = "cov1", TypeTo = "factor")
} # }
```
