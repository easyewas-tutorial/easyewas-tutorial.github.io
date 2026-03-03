# Load all data files for EWAS module

Upload sample data and methylation data for EWAS analysis.

## Usage

``` r
loadEWAS(input, ExpoPath = NULL, MethyPath = NULL, ExpoData = "default",
MethyData = "default")
```

## Arguments

- input:

  An R6 class integrated with all the information obtained from the
  initEWAS function.

- ExpoPath:

  The path to store the user's sample data. Each row represents a
  sample, and each column represents a variable (exposure variable or
  covariate). Both .csv and .xlsx file types are supported. The first
  column must be the sample ID, which must be consistent with the IDs in
  the methylation data.

- MethyPath:

  The path to store the user's methylation data. Each row represents a
  CpG site, and each column represents a sample. Both .csv and .xlsx
  file types are supported. The first column must be the CpG probes. The
  sample IDs must be consistent with the IDs in the sample data.

- ExpoData:

  The data.frame of the user-supplied sample data that has been loaded
  into the R environment. If default, the example data inside the
  package is used. The first column must be the sample name.

- MethyData:

  The data.frame of the user-supplied methylation data that has been
  loaded into the R environment. If default, an example of methylation
  data inside the package is loaded. The first column must be the CpG
  site name.

## Value

input, an R6 class object integrating all information.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
res <- loadEWAS(input = res, ExpoData = "default", MethyData = "default")
} # }
```
