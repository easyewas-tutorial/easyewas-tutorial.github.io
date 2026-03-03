# Visualize the results of EWAS analysis

Visualize EWAS results based on the
[`CMplot`](https://rdrr.io/pkg/CMplot/man/CMplot-package.html) package,
including Manhattan plots, QQ plots, etc. Please note that this function
only supports plotting a single-layer circular Manhattan plot.
Additionally, the meaning of each parameter in this function is exactly
the same as in
[`CMplot`](https://rdrr.io/pkg/CMplot/man/CMplot-package.html) For more
detailed information or to create multi-layer circular Manhattan plots,
please refer to
[`CMplot`](https://rdrr.io/pkg/CMplot/man/CMplot-package.html)
(https://cran.r-project.org/web/packages/CMplot/index.html).

## Usage

``` r
plotEWAS(
  input,
  p = "PVAL",
  threshold = NULL,
  file = c("jpg", "pdf", "tiff", "png"),
  col = c("#4197d8", "#f8c120", "#413496", "#495226", "#d60b6f", "#e66519", "#d581b7",
    "#83d3ad", "#7c162c", "#26755d"),
  bin.size = 1e+06,
  bin.breaks = NULL,
  LOG10 = TRUE,
  pch = 19,
  type = "p",
  band = 1,
  H = 1.5,
  ylim = NULL,
  axis.cex = 1,
  axis.lwd = 1.5,
  lab.cex = 1.5,
  lab.font = 2,
  plot.type = c("m", "c", "q", "d"),
  multracks = FALSE,
  multracks.xaxis = FALSE,
  multraits = FALSE,
  points.alpha = 100L,
  r = 0.3,
  cex = c(0.5, 1, 1),
  outward = FALSE,
  ylab = expression(-log[10](italic(p))),
  ylab.pos = 3,
  xticks.pos = 1,
  mar = c(3, 6, 3, 3),
  mar.between = 0,
  threshold.col = "red",
  threshold.lwd = 1,
  threshold.lty = 2,
  amplify = FALSE,
  signal.cex = 1.5,
  signal.pch = 19,
  signal.col = NULL,
  signal.line = 2,
  highlight = NULL,
  highlight.cex = 1,
  highlight.pch = 19,
  highlight.type = "p",
  highlight.col = "red",
  highlight.text = NULL,
  highlight.text.col = "black",
  highlight.text.cex = 1,
  highlight.text.font = 3,
  chr.labels = NULL,
  chr.border = FALSE,
  chr.labels.angle = 0,
  chr.den.col = "black",
  chr.pos.max = FALSE,
  cir.band = 1,
  cir.chr = TRUE,
  cir.chr.h = 1.5,
  cir.axis = TRUE,
  cir.axis.col = "black",
  cir.axis.grid = TRUE,
  conf.int = TRUE,
  conf.int.col = NULL,
  file.output = TRUE,
  file.name = "",
  dpi = 300,
  height = NULL,
  width = NULL,
  main = "",
  main.cex = 1.5,
  main.font = 2,
  legend.ncol = NULL,
  legend.cex = 1,
  legend.pos = c("left", "middle", "right"),
  box = FALSE,
  verbose = FALSE
)
```

## Arguments

- input:

  An R6 class integrated with all the information obtained from the
  startEWAS function.

- p:

  The user needs to specify the name of the p value selected for the
  result visualization.

- threshold:

  The significant threshold.If threshold = 0 or NULL, then the threshold
  line will not be added.

- file:

  The format of the output image file, including "jpg","pdf","tiff", and
  "png".

- col:

  A vector specifies the colors for the chromosomes. If the length of
  col is shorter than the number of chromosomes, the colors will be
  applied cyclically.

- bin.size:

  a integer, the size of bin in bp for marker density plot.

- bin.breaks:

  a vector, set the breaks for the legend of density plot, e.g.,
  seq(min, max, step), the windows in which the number of markers is out
  of the this range will be plotted in the same colors with the min or
  max value.

- LOG10:

  logical, whether to change the p-value into log10(p-value) scale.

- pch:

  a integer, the shape for the points, is the same with "pch" in
  [`plot`](https://rdrr.io/r/graphics/plot.default.html).

- type:

  a character, could be "p" (point), "l" (cross line), "h" (vertical
  lines) and so on, is the same with "type" in
  [`plot`](https://rdrr.io/r/graphics/plot.default.html).

- band:

  a number, the size of space between chromosomes, the default is 1.

- H:

  A number controlling the height of the circular Manhattan track.

- ylim:

  vector (c(min, max)), CMplot will only plot the points among this
  interval.

- axis.cex:

  a number, controls the size of ticks labels of X/Y-axis and the ticks
  labels of axis for circle plot.

- axis.lwd:

  a number, controls the thickness of X/Y-axis lines and the thickness
  of axis for circle plot.

- lab.cex:

  a number, controls the size of labels of X/Y-axis and the labels of
  chromosomes for circle plot.

- lab.font:

  a number, controls the font of labels of all axis.

- plot.type:

  a character or vector, only "d", "c", "m", "q" can be used. if
  plot.type="d", CpG density will be plotted; if plot.type="c", only
  circle-Manhattan plot will be plotted; if plot.type="m",only Manhattan
  plot will be plotted; if plot.type="q",only Q-Q plot will be plotted;
  if plot.type=c("m","q"), Both Manhattan and Q-Q plots will be plotted.

- multracks:

  Logical. Whether to use multi-track mode in CMplot.

- multracks.xaxis:

  Logical. Whether to draw x-axis in multi-track mode.

- multraits:

  Logical. Whether to use multi-trait mode in CMplot.

- points.alpha:

  Integer. Transparency (alpha) value for points (0–255). Default is
  100.

- r:

  a number, the radius for the circle (the inside radius), the default
  is 1.

- cex:

  a number or a vector, the size for the points, is the same with "size"
  in [`plot`](https://rdrr.io/r/graphics/plot.default.html), and if it
  is a vector, the first number controls the size of points in circle
  plot(the default is 0.5), the second number controls the size of
  points in Manhattan plot (the default is 1), the third number controls
  the size of points in Q-Q plot (the default is 1)

- outward:

  logical, if TRUE, all points will be plotted from inside to outside
  for circular Manhattan plot.

- ylab:

  a character, the labels for y axis.

- ylab.pos:

  the distance between ylab and yaxis.

- xticks.pos:

  the distance between labels of x ticks and x axis.

- mar:

  the size of white gaps around the plot, 4 values should be provided,
  indicating the direction of bottom, left, up, and right.

- mar.between:

  Space between tracks for multi-track plotting.

- threshold.col:

  a character or vector, the color for the line of threshold levels, it
  can also control the color of the diagonal line of QQplot.

- threshold.lwd:

  a number or vector, the width for the line of threshold levels, it can
  also control the thickness of the diagonal line of QQplot.

- threshold.lty:

  a number or vector, the type for the line of threshold levels, it can
  also control the type of the diagonal line of QQplot

- amplify:

  logical, CMplot can amplify the significant points, if TRUE, then the
  points bigger than the minimal significant level will be amplified,
  the default: amplify=TRUE.

- signal.cex:

  a number, if amplify=TRUE, users can set the size of significant
  points.

- signal.pch:

  a number, if amplify=TRUE, users can set the shape of significant
  points.

- signal.col:

  a character, if amplify=TRUE, users can set the colour of significant
  points, if signal.col=NULL, then the colors of significant points will
  not be changed.

- signal.line:

  a number, the thickness of the lines of significant CpGs cross the
  circle.

- highlight:

  a vector, names of CpGs which need to be highlighted.

- highlight.cex:

  a vector, the size of points for CpGs which need to be highlighted.

- highlight.pch:

  a vector, the pch of points for CpGs which need to be highlighted.

- highlight.type:

  a vector, the type of points for CpGs which need to be highlighted.

- highlight.col:

  a vector, the col of points for CpGs which need to be highlighted.

- highlight.text:

  a vector, the text which would be added around the highlighted CpGs.

- highlight.text.col:

  a vector, the color for added text.

- highlight.text.cex:

  a value, the size for added text.

- highlight.text.font:

  text font for the highlighted CpGs

- chr.labels:

  a vector, the labels for the chromosomes of density plot and Manhattan
  plot.

- chr.border:

  a logical, whether to plot the dot line between chromosomes.

- chr.labels.angle:

  a value, rotate tick labels of x-axis for Manhattan plot (-90 \<
  chr.labels.angle \< 90).

- chr.den.col:

  a character or vector or NULL, the colour for the CpG density. If the
  length of parameter 'chr.den.col' is bigger than 1, CpG density that
  counts the number of CpG within given size ('bin.size') will be
  plotted around the circle. If chr.den.col=NULL, the density bar will
  not be attached on the bottom of manhattan plot.

- chr.pos.max:

  logical, whether the physical positions of each chromosome contain the
  maximum length of the chromosome.

- cir.band:

  A number controlling the spacing between circular tracks.

- cir.chr:

  logical, a boundary that represents chromosomes will be plotted on the
  periphery of a circle, the default is TRUE.

- cir.chr.h:

  a number, the width for the boundary, if cir.chr=FALSE, then this
  parameter will be useless.

- cir.axis:

  a logical, whether to add the axis of circle Manhattan plot.

- cir.axis.col:

  a character, the color of the axis for circle.

- cir.axis.grid:

  logical, whether to add axis grid line in circles.

- conf.int:

  logical, whether to plot confidence interval on QQ-plot.

- conf.int.col:

  character or vector, the color of confidence interval of QQplot.

- file.output:

  a logical, users can choose whether to output the plot results.

- file.name:

  a character or vector, the names of output files.

- dpi:

  a number, the picture resolution for '.jpg', '.npg', and '.tiff'
  files. The default is 300.

- height:

  the height of output files.

- width:

  the width of output files.

- main:

  character of vector, the title of the plot for manhattan plot and
  qqplot.

- main.cex:

  size of title.

- main.font:

  font of title.

- legend.ncol:

  Number of columns used in the legend.

- legend.cex:

  A numeric value controlling legend text size.

- legend.pos:

  A character value specifying legend position.

- box:

  logical, this function draws a box around the current plot.

- verbose:

  whether to print the log information.

## Value

The updated input object, including CMplot-ready data stored in
input\$CMplot.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- initEWAS(outpath = "default")
res <- loadEWAS(input = res, ExpoData = "default", MethyData = "default")
res <- transEWAS(input = res, Vars = "cov1", TypeTo = "factor")
res <- startEWAS(input = res, chipType = "EPICV2", model = "lm", expo = "var", adjustP = TRUE)
res <- plotEWAS(input = res, p = "PVAL")
} # }
```
