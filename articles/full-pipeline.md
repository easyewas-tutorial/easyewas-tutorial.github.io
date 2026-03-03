## Introduction

easyEWAS is a user-friendly R package designed for conducting
epigenome-wide association studies (EWAS). With easyEWAS, we provide a
battery of statistical methods to support differential methylation
position analysis across various scenarios, as well as differential
methylation region analysis based on the DMRcate method. To facilitate
result interpretation, we provide comprehensive functional annotation
and result visualization functionalities. Additionally, bootstrap-based
internal validation is incorporated to evaluate the robustness of EWAS
results. easyEWAS is compatible with currently most cited Illumina
high-density microarray platforms for genome-wide methylation profiling,
including 27K, 450K, EPIC V1, EPIC V2, and MSA arrays.


## Prepare Data Files

easyEWAS supports `.csv` and `.xlsx` file formats. so ensure your data is in 
one of these formats. The package also includes internal sample and methylation 
datasets for users to explore and test its functions.

### Sample data

Users need to prepare a sample file to store sample information, such as
sample ID, exposure variables, and covariates.

- The sample ID must be the first column.
- Each ID should be unique.
- IDs should be consistent across all files.

<!-- -->

    data("sampledata", package = "easyEWAS")
    head(sampledata)
    #>   SampleName var cov1     cov2 batch
    #> 1 ZE10000001  76    2 20.96810     1
    #> 2 ZE10000002  66    2 26.78373     1
    #> 3 ZE10000003  71    2 28.26081     1
    #> 4 ZE10000004  81    1 22.54459     1
    #> 5 ZE10000005  70    1 21.66550     1
    #> 6 ZE10000006  68    2 16.94033     1

### Methylation data

Users also need a methylation file where each row represents a CpG site
and each column represents a sample.

    data("methydata", package = "easyEWAS")
    head(methydata[, 1:6])
    #>             probe ZE10000001 ZE10000002 ZE10000003 ZE10000004 ZE10000005
    #> 1 cg01444397_BC11 0.04768038 0.02783589 0.02852848 0.06711713 0.04478172
    #> 2 cg12110931_TC11 0.43900591 0.43166163 0.51290795 0.45075799 0.59972834
    #> 3 cg12258811_TC21 0.41950433 0.47744150 0.52750836 0.53600388 0.64258103
    #> 4 cg08764927_TC21 0.82080027 0.82292072 0.88725030 0.87222326 0.91267532
    #> 5 cg25514503_TC21 0.94965507 0.95133812 0.95787150 0.96158814 0.96021148
    #> 6 cg24454741_TC21 0.88100024 0.89587378 0.90661704 0.88505037 0.86547789

## Analysis pipeline

### Library the package

    library(easyEWAS)
    #> 
    #> Welcome to easyEWAS 1.1.0!
    #> =============================
    #> Flexible and user-friendly tools for Epigenome-Wide Association Studies.
    #> 
    #> Authors: Yuting Wang & Xu Gao (Corresponding author)
    #> Documentation: https://easyewas-tutorial.github.io/
    #> Citation:https://doi.org/10.1093/bioadv/vbaf026

### Step 1: Initialize the EWAS module

After loading easyEWAS, users can initialize the analysis module with
[`initEWAS()`](../reference/initEWAS.html). This creates a folder named
`EWASresult` under the working path. If `outpath = "default"`, results
are stored in the current working directory.

    res <- initEWAS(outpath = "default")
    #> EWAS module has been successfully initialized.
    #> Results will be saved to: /Users/yuting/Documents/EWASresult
    #> Initialization time: 2026-03-03 12:12:56.282611
    #> 0.002 sec elapsed

When specifying a custom storage path, make sure the path exists.

    res <- initEWAS(outpath = "D:/test")

Note: The function returns an R6 object integrating all information, so
assign it to an object such as `res`.

### Step 2: Load the Data Files

Users can upload sample and methylation data in two ways:

- assign data objects in the R environment (`ExpoData`, `MethyData`)
- read from files (`ExpoPath`, `MethyPath`)

Detailed information is available at [`loadEWAS`
documentation](../reference/loadEWAS.html).

    # Read from environment.
    # Or read from file paths:
    # ExpoPath = "D:/DATA/dat1.csv", MethyPath = "D:/DATA/dat2.csv"
    res <- loadEWAS(
      input = res,
      ExpoData = sampledata,
      MethyData = methydata
    )
    #> All data files have been successfully loaded.
    #> Timestamp: 2026-03-03 12:12:56.286563
    #> 0.001 sec elapsed

`input` should be the `res` generated in Step 1.

### Step 3: Transform variable types

This is optional. Users can transform selected variables in sample data
to `factor` or `numeric` via
[`transEWAS()`](../reference/transEWAS.html).

    res <- transEWAS(input = res, Vars = "cov1", TypeTo = "factor")
    #> Variable type conversion completed successfully.
    #> Converted variables: cov1
    #> Target type: factor
    #> Timestamp: 2026-03-03 12:12:56.288697
    #> 0.01 sec elapsed

### Step 4: Remove batch effects

This is optional. Batch correction is based on ComBat (`sva` package)
and requires known batch information in sample metadata.Batch effect correction
is based on the ComBat function from the `sva` package. The sample data provided
by the user must include known batch information. Before correcting for batch
effects, the user can specify the name of the batch in the `batch` parameter, 
as well as the names of the variates of interest and other covariates besides
batch in the `adjustVarparameter` to avoid overcorrection.

The corrected methylation data will replace `res$Data$Methy`.

Detailed information is available at [`batchEWAS`
documentation](../reference/batchEWAS.html).

    res <- batchEWAS(input = res, adjustVar = "var", batch = "batch")
    #> Starting batch effect adjustment using ComBat. This may take some time...
    #> Found2batches
    #> Adjusting for1covariate(s) or covariate level(s)
    #> Standardizing Data across genes
    #> Fitting L/S model and finding priors
    #> Finding parametric adjustments
    #> Adjusting the Data
    #> Batch effect adjustment completed successfully.
    #> Adjusted methylation data is stored in: input$Data$Methy
    #> Timestamp: 2026-03-03 12:12:56.946095
    #> 0.646 sec elapsed

If `plot = TRUE`, prior plots are generated.

    res <- batchEWAS(input = res, adjustVar = "var", batch = "batch", plot = TRUE)

### Step 5: Perform the EWAS analysis

This is the core step. The user can select models based on the analysis 
requirements, including linear regression models, linear mixed effects models, 
and Cox proportional risk models.The results can be exported to a file in 
working directory. 

Detailed information is available at [`startEWAS`
documentation](../reference/startEWAS.html).

    parallel::detectCores() - 1 # Maximum recommended number of cores
    #> [1] 9

    res <- startEWAS(
      input = res,
      chipType = "EPICV2", # "EPICV1", "450K", "27K", "MSA"
      model = "lm",        # "lm", "lmer", "cox"
      expo = "var",        # exposure variable
      cov = "cov1,cov2",   # covariates
      adjustP = TRUE,       # adjust p-values (FDR and Bonferroni)
      random = NULL,        # set only for lmer
      time = NULL,          # set only for cox
      status = NULL,        # set only for cox
      core = 4             # set cores for parallel operations
    )
    #> Starting EWAS data preprocessing ...
    #> EWAS data preprocessing completed in 0 seconds.
    #> Starting parallel computation setup ...
    #> Parallel setup completed in 4.28 seconds.
    #> Running parallel EWAS model fitting ...
    #> Parallel EWAS model fitting completed in 0.25 seconds.
    #> Multiple testing correction completed!
    #> Start CpG sites annotation ...
    #> Using annotation for chip type: EPICV2 (Genome: hg38 (GRCh38))
    #> EWAS analysis has been completed! You can find results in /Users/yuting/Documents/EWASresult.
    #> 2026-03-03 12:13:02.996542
    #> 6.043 sec elapsed

The results can be viewed in `res$result`.For linear regression and linear 
mixed-effects models, when the exposure variable is continuous, the output 
includes the coefficient (per unit, per IQR, per SD), standard error, 
significance P-value, adjusted P-value, and annotation for each site. For 
categorical variables, coefficients are provided for each class relative to 
the reference group. In Cox proportional hazards models, hazard ratios (HR) 
and confidence intervals are also included.

    head(res$result)
    #>             probe          BETA    BETA_perSD   BETA_perIQR           SE
    #> 1 cg01444397_BC11  5.724133e-04  5.345447e-03  0.0087293025 1.594601e-04
    #> 2 cg12110931_TC11  2.012009e-03  1.878903e-02  0.0306831439 6.058078e-04
    #> 3 cg12258811_TC21  1.917825e-04  1.790949e-03  0.0029246826 5.173171e-04
    #> 4 cg08764927_TC21 -3.726331e-05 -3.479812e-04 -0.0005682655 4.552721e-04
    #> 5 cg25514503_TC21  6.708728e-06  6.264905e-05  0.0001023081 8.123277e-05
    #> 6 cg24454741_TC21 -6.095697e-05 -5.692430e-04 -0.0009295938 1.282312e-04
    #>       SE_perSD   SE_perIQR         PVAL       FDR Bonfferoni chr     pos
    #> 1 0.0014891086 0.002431767 0.0005237102 0.1059711   0.645211   1 7784390
    #> 2 0.0056572995 0.009238568 0.0012686133 0.1214434   1.000000   1 7784577
    #> 3 0.0048309345 0.007889085 0.7116590121 0.9001683   1.000000   1 7784675
    #> 4 0.0042515312 0.006942899 0.9349376448 0.9720196   1.000000   1 7784835
    #> 5 0.0007585874 0.001238800 0.9343523148 0.9720196   1.000000   1 7785010
    #> 6 0.0011974795 0.001955526 0.6356047918 0.8722169   1.000000   1 7785177
    #>   relation_to_island
    #> 1             Island
    #> 2             Island
    #> 3             Island
    #> 4             Island
    #> 5             Island
    #> 6              Shore
    #>                                                                    gene
    #> 1                          PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3
    #> 2                                                                      
    #> 3 PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3
    #> 4 PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3;PER3
    #> 5                                                                      
    #> 6                                                                      
    #>                                                                              location
    #> 1                              5UTR;exon_1;5UTR;exon_1;5UTR;exon_1;5UTR;exon_1;TSS200
    #> 2                                                                                    
    #> 3 5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2
    #> 4 5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2;5UTR;exon_2
    #> 5                                                                                    
    #> 6

## Downstream Analysis

### Option 1: EWAS results visualization

Use [`plotEWAS()`](../reference/plotEWAS.html) to generate Manhattan,
QQ, and related plots.

- `p`: `"PVAL"`, `"FDR"`, `"Bonfferoni"`
- `threshold`: significance line for Manhattan plot

There are many other parameters for users to customize their plots. Detailed 
information can be found in Reference page.

<!-- -->

    res <- plotEWAS(
      input = res,
      file = "pdf", # "jpg", "png", "tif", "pdf"
      p = "PVAL",   # "PVAL", "FDR", "Bonfferoni"
      threshold = 0.05
    )
    #> No file name provided. Output images will use default names from CMplot.
    #> Starting EWAS result visualization using CMplot...
    #> EWAS visualization completed successfully.
    #> Plots saved to: /Users/yuting/Documents/EWASresult.
    #> Timestamp: 2026-03-03 12:13:03.095174
    #> 0.093 sec elapsed

### Option 2: Internal validation with bootstrap

Bootstrap is a statistical resampling technique used for internal validation 
and estimation of uncertainty in statistical models. The parameter `bootCI` 
refers to the type of confidence interval calculation methods, 
including “norm”, “basic”, “stud”, “perc” (the default), and “bca”.
Users can select CpG sites to validate in two ways. 

1.  Filter by significance column and cutoff:

<!-- -->

    res <- bootEWAS(
      input = res,
      filterP = "PVAL", # "FDR", "Bonfferoni"
      cutoff = 0.001,
      bootCI = "perc",
      times = 100
    )
    #> Starting bootstrap-based internal validation...
    #> 10 CpG sites selected by PVAL < 0.001
    #> 10 CpG sites selected for bootstrap analysis.
    #> Bootstrap confidence interval method: perc.
    #> Bootstrap analysis for cg01444397_BC11...
    #> Bootstrap analysis for cg26269881_BC21...
    #> Bootstrap analysis for cg08693699_BC21...
    #> Bootstrap analysis for cg14151354_BC21...
    #> Bootstrap analysis for cg13515269_TC21...
    #> Bootstrap analysis for cg16047471_BC21...
    #> Bootstrap analysis for cg00200653_TC11...
    #> Bootstrap analysis for cg04162685_BC21...
    #> Bootstrap analysis for cg24867447_BC21...
    #> Bootstrap analysis for cg25069388_BC21...
    #> Bootstrap for internal validation has been completed!
    #> You can find results in /Users/yuting/Documents/EWASresult.
    #> 2026-03-03 12:13:03.41437
    #> 0.317 sec elapsed

    head(res$bootres)
    #> # A tibble: 6 × 4
    #>   probe            original  lower_CI  upper_CI
    #>   <chr>               <dbl>     <dbl>     <dbl>
    #> 1 cg01444397_BC11  0.000572  0.000130  0.000977
    #> 2 cg26269881_BC21 -0.00232  -0.00380  -0.000909
    #> 3 cg08693699_BC21 -0.00113  -0.00168  -0.000397
    #> 4 cg14151354_BC21 -0.000746 -0.00121  -0.000313
    #> 5 cg13515269_TC21 -0.00135  -0.00224  -0.000679
    #> 6 cg16047471_BC21 -0.00183  -0.00279  -0.000805

1.  Specify CpG names directly:

<!-- -->

    res <- bootEWAS(
      input = res,
      CpGs = "cg01444397_BC11,cg08693699_BC21,cg16047471_BC21",
      bootCI = "perc",
      times = 100
    )

### Option 3: Enrichment analysis

easyEWAS provides GO/KEGG enrichment based on clusterProfiler.

- `method`: `"GO"` or `"KEGG"`
- `filterP` + `cutoff`: site selection
- `ont`: `"BP"`, `"MF"`, `"CC"`, `"ALL"`, only available when choosing `GO` 
enrichment method. 

Additionally, the function can visualize the enrichment 
analysis results, including both dotplot and barplot. The colors in the plot 
can be based on the values of `pvalue`, `p.adjust`, or `qvalue`, with `pvalue` 
being the default.

Detailed information is available at [`enrichEWAS`
documentation](../reference/enrichEWAS.html).

    res <- enrichEWAS(
      input = res,
      method = "GO",
      filterP = "PVAL",      # "PVAL", "FDR", "Bonfferoni"
      cutoff = 0.01,
      ont = "BP",            # "BP", "MF", "CC", "ALL"
      plot = TRUE,
      plotType = "dot",      # "bar", "dot"
      plotcolor = "pvalue",  # "pvalue", "p.adjust", "qvalue"
      showCategory = 10
    )
    #> 
    #> Converting gene symbols to Entrez IDs...
    #> Gene symbol conversion completed: 5 gene(s) mapped.
    #> Starting GO enrichment analysis using clusterProfiler ...
    #> Visualizing enrichment results as a dot plot ...
    #> Plot saved to: /Users/yuting/Documents/EWASresult/enrichdot.pdf
    #> Enrichment analysis has been completed! 
    #> You can find results in /Users/yuting/Documents/EWASresult.
    #> 2026-03-03 12:13:14.011387
    #> 10.581 sec elapsed

    head(res$enrichres)
    #>                    ID
    #> GO:0048511 GO:0048511
    #> GO:0032922 GO:0032922
    #> GO:0032434 GO:0032434
    #> GO:0010508 GO:0010508
    #> GO:2000058 GO:2000058
    #> GO:0061136 GO:0061136
    #>                                                                        Description
    #> GO:0048511                                                        rhythmic process
    #> GO:0032922                                 circadian regulation of gene expression
    #> GO:0032434 regulation of proteasomal ubiquitin-dependent protein catabolic process
    #> GO:0010508                                        positive regulation of autophagy
    #> GO:2000058             regulation of ubiquitin-dependent protein catabolic process
    #> GO:0061136                     regulation of proteasomal protein catabolic process
    #>            GeneRatio   BgRatio  RichFactor FoldEnrichment    zScore
    #> GO:0048511       3/5 302/18860 0.009933775       37.47020 10.404161
    #> GO:0032922       2/5  67/18860 0.029850746      112.59701 14.901260
    #> GO:0032434       2/5 139/18860 0.014388489       54.27338 10.265597
    #> GO:0010508       2/5 176/18860 0.011363636       42.86364  9.086349
    #> GO:2000058       2/5 178/18860 0.011235955       42.38202  9.033189
    #> GO:0061136       2/5 209/18860 0.009569378       36.09569  8.308201
    #>                  pvalue   p.adjust      qvalue               geneID Count
    #> GO:0048511 3.969643e-05 0.01171045 0.003927857 PER3/BHLHE41/CSNK2A1     3
    #> GO:0032922 1.234701e-04 0.01821184 0.006108521         PER3/BHLHE41     2
    #> GO:0032434 5.315103e-04 0.04749564 0.015930740      CSNK1A1/CSNK2A1     2
    #> GO:0010508 8.500749e-04 0.04749564 0.015930740      CSNK1A1/CSNK2A1     2
    #> GO:2000058 8.693751e-04 0.04749564 0.015930740      CSNK1A1/CSNK2A1     2
    #> GO:0061136 1.195607e-03 0.04749564 0.015930740      CSNK1A1/CSNK2A1     2

### Option 4: DMR analysis

easyEWAS integrates `DMRcate` package for DMR analysis. As in DMP analysis,
specify exposure variable, covariates, chip type, and methylation value
type (β-values or M-values). It is recommended to use the default settings 
for parameters such as `lambda`, `C`, `fdrCPG`, `pcutoff`, and `min.cpgs` 
for DMR selection.

Detailed information is available at [`dmrEWAS`
documentation](../reference/dmrEWAS.html).

    res <- dmrEWAS(
      input = res,
      chipType = "EPICV2",
      what = "Beta",
      expo = "var",
      cov = "cov1,cov2",
      genome = "hg38",
      lambda = 1000,
      C = 2,
      pcutoff = 0.05
    )
    #> Registered S3 methods overwritten by 'readr':
    #>   method                    from 
    #>   as.data.frame.spec_tbl_df vroom
    #>   as_tibble.spec_tbl_df     vroom
    #>   format.col_spec           vroom
    #>   print.col_spec            vroom
    #>   print.collector           vroom
    #>   print.date_names          vroom
    #>   print.locale              vroom
    #>   str.col_spec              vroom
    #> Setting options('download.file.method.GEOquery'='auto')
    #> Setting options('GEOquery.inmemory.gpl'=FALSE)
    #> Starting the differentially methylated region analysis. Please be patient...
    #> EPICv2 detected. Filtering position replicates using method: 'mean'...
    #> 1216 CpGs used for DMR analysis.
    #> 12 DMRs detected.
    #> DMR result has been saved to: /Users/yuting/Documents/EWASresult/DMRresult.csv
    #> DMR analysis completed successfully.
    #> Timestamp: 2026-03-03 12:13:47.864385
    #> 31.217 sec elapsed

    head(res$dmrres)
    #>   seqnames     start       end width strand no.cpgs min_smoothed_fdr
    #> 1    chr12  26121435  26121868   434      *       3     0.0006926403
    #> 2     chr1   7826573   7827921  1349      *      10     0.0053198587
    #> 3     chr1   7784390   7784835   446      *       4     0.0053198587
    #> 4     chr3   4981365   4981709   345      *       3     0.0054574766
    #> 5     chr2 100924866 100925130   265      *       5     0.0081198870
    #> 6    chr15  60591026  60591370   345      *       2     0.0081198870
    #>       Stouffer       HMFDR       Fisher      maxdiff      meandiff
    #> 1 2.827015e-04 0.002443061 0.0001300913 -0.001834445 -0.0011539964
    #> 2 6.166338e-06 0.039505450 0.0001300913 -0.002527727 -0.0012950516
    #> 3 4.259913e-03 0.003212979 0.0007271626  0.002012009  0.0006847355
    #> 4 3.654183e-04 0.003212979 0.0007015946 -0.002322104 -0.0015218217
    #> 5 3.580945e-04 0.016418020 0.0007015946 -0.002072670 -0.0013957993
    #> 6 1.749110e-03 0.003092856 0.0013320402 -0.001368543 -0.0006471749
    #>   overlapping.genes
    #> 1           BHLHE41
    #> 2    PER3, Z98884.1
    #> 3              PER3
    #> 4           BHLHE40
    #> 5             NPAS2
    #> 6    RORA-AS1, RORA

## Reference

1.  Hall P (1992). *The Bootstrap and Edgeworth Expansion*. Springer,
    New York. ISBN 9781461243847.
2.  <https://CRAN.R-project.org/package=CMplot>
3.  Yu G, Wang LG, Han Y, He QY (2012). clusterProfiler: an R package
    for comparing biological themes among gene clusters. *OMICS*
    16(5):284-287. <https://doi.org/10.1089/omi.2011.0118>
4.  Leek JT, Johnson WE, Parker HS, Jaffe AE, Storey JD (2012). The sva
    package for removing batch effects and other unwanted variation in
    high-throughput experiments. *Bioinformatics* 28(6):882-883.
    <https://doi.org/10.1093/bioinformatics/bts034>
5.  Peters TJ, Buckley MJ, Statham AL, Pidsley R, Samaras K, Lord RV,
    Clark SJ, Molloy PL (2015). De novo identification of differentially
    methylated regions in the human genome. *Epigenetics & Chromatin*
    8:6. <https://doi.org/10.1186/1756-8935-8-6>
