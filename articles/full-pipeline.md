# easyEWAS Demo Data Full Tutorial

This tutorial uses built-in demo data (`sampledata`, `methydata`) and
walks through a complete `easyEWAS` workflow. For each step, it
explains:

- key parameters
- required input
- returned object in memory
- files written to disk

## Workflow map

| Step | Function | Main goal | In-memory output | File output |
|----|----|----|----|----|
| 0 | [`downloadAnnotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/downloadAnnotEWAS.md) | Cache chip annotation | (cache only) | annotation `.rds` under user cache |
| 1 | [`initEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/initEWAS.md) | Initialize project object and output folder | `res$outpath`, empty `res$Data` | create `EWASresult/` |
| 2 | [`loadEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/loadEWAS.md) | Load sample + methylation matrices | `res$Data$Expo`, `res$Data$Methy` | none |
| 3 | [`transEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/transEWAS.md) | Convert variable types | updated `res$Data$Expo` | none |
| 4 | [`batchEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/batchEWAS.md) | Remove batch effects with ComBat | updated `res$Data$Methy` | `combat_plots.pdf` (if `plot = TRUE`) |
| 5 | [`startEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/startEWAS.md) | Run EWAS model and annotation | `res$result`, `res$model`, `res$formula` | `ewasresult.csv` (or custom) |
| 6 | [`plotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/plotEWAS.md) | Manhattan / QQ / circular plots | `res$CMplot` | image files under `res$outpath` |
| 7 | [`bootEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/bootEWAS.md) | Bootstrap internal validation | `res$bootres` | `bootresult.csv` (or custom) |
| 8 | [`enrichEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/enrichEWAS.md) | GO/KEGG enrichment | `res$enrichres` | `enrichresult.csv` + optional PDF |
| 9 | [`dmrEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/dmrEWAS.md) | DMR detection (optional) | `res$dmrres` | `DMRresult.csv` (or custom) |

## 0. Setup and annotation cache

Key parameters:

- `chipType`: one of `"27K"`, `"450K"`, `"EPICV1"`, `"EPICV2"`, `"MSA"`

Input:

- none

Output:

- annotation file cached locally (used later by
  [`startEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/startEWAS.md))

``` r

library(easyEWAS)
downloadAnnotEWAS(chipType = "EPICV2")
```

## 1. Initialize analysis object

Key parameters:

- `outpath = "default"`: create `EWASresult/` under current working
  directory

Input:

- none

Output:

- in memory: `res` (R6 object), with `res$outpath`
- on disk: `<working_directory>/EWASresult/`

``` r

res <- initEWAS(outpath = "default")
res$outpath
```

## 2. Load demo data

Key parameters:

- `ExpoData = sampledata`
- `MethyData = methydata`

Input:

- `sampledata`: sample-level metadata; first column must be sample IDs
- `methydata`: CpG-by-sample matrix; first column must be probe IDs

Output:

- in memory: `res$Data$Expo`, `res$Data$Methy`
- on disk: none

``` r

res <- loadEWAS(
  input = res,
  ExpoData = sampledata,
  MethyData = methydata
)

str(res$Data$Expo)
dim(res$Data$Methy)
```

## 3. Convert variable types

Key parameters:

- `Vars`: comma-separated variable names in `res$Data$Expo`
- `TypeTo`: `"factor"` or `"numeric"`

Input:

- `res$Data$Expo` from Step 2

Output:

- in memory: selected columns updated in `res$Data$Expo`
- on disk: none

``` r

res <- transEWAS(
  input = res,
  Vars = "cov1,var",
  TypeTo = "factor"
)
```

## 4. Batch effect adjustment

Key parameters:

- `batch`: batch column name in sample metadata
- `adjustVar`: covariates to preserve during ComBat
- `plot = TRUE`: save prior diagnostic plot

Input:

- `res$Data$Methy` and `res$Data$Expo`

Output:

- in memory: corrected methylation matrix in `res$Data$Methy`
- on disk: `combat_plots.pdf` (when `plot = TRUE`)

``` r

res <- batchEWAS(
  input = res,
  adjustVar = "cov1,cov2",
  batch = "batch",
  plot = TRUE,
  par.prior = TRUE,
  mean.only = FALSE,
  ref.batch = NULL,
  parallel = FALSE
)
```

## 5. Run EWAS

Key parameters:

- `model`: `"lm"`, `"lmer"`, or `"cox"`
- `expo`: exposure variable
- `cov`: comma-separated covariates
- `chipType`: annotation platform
- `filename`: output CSV name (`"default"` -\> `ewasresult.csv`)

Input:

- corrected methylation matrix + sample metadata in `res`

Output:

- in memory: `res$result`, `res$model`, `res$formula`, `res$covdata`
- on disk: `<outpath>/ewasresult.csv` (or `<filename>.csv`)

``` r

res <- startEWAS(
  input = res,
  filename = "ewas_lm",
  model = "lm",
  expo = "var",
  cov = "cov1,cov2",
  chipType = "EPICV2",
  adjustP = TRUE,
  core = "default"
)

head(res$result)
```

## 6. Plot EWAS results

Key parameters:

- `p`: p-value column from `res$result` (for example `"PVAL"` or
  `"FDR"`)
- `plot.type`: `"m"` (Manhattan), `"q"` (QQ), `"c"` (circular), `"d"`
  (density)
- `file` and `file.name`: image format and prefix

Input:

- `res$result` with annotation columns (`chr`, `pos`)

Output:

- in memory: `res$CMplot`
- on disk: plot files under `res$outpath`

``` r

res <- plotEWAS(
  input = res,
  p = "PVAL",
  threshold = 0.05,
  plot.type = c("m", "q"),
  file = "jpg",
  file.name = "EWAS_plot"
)
```

## 7. Bootstrap internal validation

Key parameters:

- `filterP`: significance column used to select CpGs
- `cutoff`: threshold for CpG selection
- `times`: bootstrap iterations
- `bootCI`: confidence interval method (`"perc"` commonly used)

Input:

- `res$result`, plus model context in `res` (`res$model`, `res$formula`)

Output:

- in memory: `res$bootres`
- on disk: `<outpath>/bootresult.csv` (or custom filename)

``` r

res <- bootEWAS(
  input = res,
  filterP = "PVAL",
  cutoff = 0.001,
  times = 100,
  bootCI = "perc",
  filename = "boot_lm"
)
```

## 8. Enrichment analysis

Key parameters:

- `method`: `"GO"` or `"KEGG"`
- `filterP` + `cutoff`: select significant genes from EWAS result
- `plot`, `plotType`: whether to save dot/bar enrichment figure

Input:

- gene symbols from EWAS result column `gene`

Output:

- in memory: `res$enrichres`
- on disk: enrichment CSV + optional PDF plot

``` r

res <- enrichEWAS(
  input = res,
  method = "GO",
  ont = "BP",
  filterP = "PVAL",
  cutoff = 0.05,
  pAdjustMethod = "BH",
  plot = TRUE,
  plotType = "dot",
  plotcolor = "p.adjust",
  showCategory = 10,
  filename = "go_enrich"
)
```

## 9. DMR analysis (optional)

Key parameters:

- `chipType` and `genome` must match platform (for EPICV2 use `hg38`)
- `epicv2Filter`: EPICv2 replicate probe handling strategy
- `lambda`, `C`, `min.cpgs`: region calling sensitivity

Input:

- `res$Data$Methy` + `res$Data$Expo`

Output:

- in memory: `res$dmrres`
- on disk: `<outpath>/DMRresult.csv` (or custom filename)

``` r

BiocManager::install("DMRcate")

res <- dmrEWAS(
  input = res,
  chipType = "EPICV2",
  what = "Beta",
  epicv2Filter = "mean",
  expo = "var",
  cov = "cov1,cov2",
  genome = "hg38",
  fdrCPG = 0.05,
  pcutoff = "fdr",
  lambda = 1000,
  C = 2,
  min.cpgs = 2,
  filename = "dmr_result"
)
```

## Final output checklist

After this pipeline, check these common outputs in `res$outpath`:

- `ewas_lm.csv` (or `ewasresult.csv`)
- `combat_plots.pdf` (if batch step with `plot = TRUE`)
- EWAS plot image files from
  [`plotEWAS()`](https://ytwangZero.github.io/easyEWAS/reference/plotEWAS.md)
- `boot_lm.csv` (or `bootresult.csv`)
- `go_enrich.csv` and `go_enrich.pdf` (if enrichment plot enabled)
- `dmr_result.csv` (if DMR analysis is run)
