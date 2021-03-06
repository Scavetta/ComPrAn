% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/twoGroupsWithinLabelCoMigration.R
\name{twoGroupsWithinLabelCoMigration}
\alias{twoGroupsWithinLabelCoMigration}
\title{Compare a Two Groups of Proteins Within One Label State}
\usage{
twoGroupsWithinLabelCoMigration(
  dataFrame,
  max_frac,
  group1Data = NULL,
  group1Name = "group1",
  group2Data = NULL,
  group2Name = "group2",
  meanLine = FALSE,
  medianLine = FALSE,
  ylabel = "Relative Protein Abundance",
  xlabel = "Fraction",
  legendLabel = "Group",
  labelled = "Labeled",
  unlabelled = "Unlabeled",
  jitterPoints = 0.3,
  pointSize = 2.5,
  grid = FALSE,
  showTitle = FALSE,
  titleAlign = "left",
  alphaValue = 1,
  textSize = 12,
  axisTextSize = 8
)
}
\arguments{
\item{dataFrame}{dataFrame: data frame, data frame of normalised values for 
proteins from SCENARIO A,
   contains columns:
  `Protein Group Accessions` character
  `Protein Descriptions` character
   Fraction integer
   isLabel character ('TRUE'/'FALSE' values)
   `Precursor Area` double
   scenario character}

\item{max_frac}{numeric, total number of fractions}

\item{group1Data}{character vector, contins list of Protein Group Accessions
that belong to the group we want to plot for group 1}

\item{group1Name}{character, name that should be used for the group 
specified in group1Data}

\item{group2Data}{character vector, contins list of Protein Group Accessions 
that belong to the group we want to plot for group 2}

\item{group2Name}{character, name that should be used for the group 
specified in group2Data}

\item{meanLine}{logical, specifies whether to plot a mean line for all 
values in the group}

\item{medianLine}{logical, specifies whether to plot a median line for all 
values in the group}

\item{ylabel}{character}

\item{xlabel}{character}

\item{legendLabel}{character}

\item{labelled}{character, label to be used for isLabel == TRUE}

\item{unlabelled}{character, label to be used for isLabel == FALSE}

\item{jitterPoints}{numeric}

\item{pointSize}{numeric, size of the point in the plot}

\item{grid}{logical, specifies presence/absence of gridline in the plot}

\item{showTitle}{logical}

\item{titleAlign}{character, one of the 'left', 'center'/'centre', 'right',
specifies alignment of the title in plot}

\item{alphaValue}{numeric, transparency of the point, values 0 to 1}

\item{textSize}{numeric, size of text in the plot}

\item{axisTextSize}{numeric, size of axis labels in the plot}
}
\value{
plot
}
\description{
This function creates a scatter plot for a subset of proteins in dataFrame 
specified in group1Data and group2Data, label states are always separated 
into facets
}
\details{
Intended use of the function - using scenario A data, compare shape of the
migration profile between a TWO GROUPS of proteins WITHIN the ONE 
LABEL STATE
}
\examples{
##Use example normalised proteins file
inputFile <- system.file("extData", "dataNormProts.txt", package ="ComPrAn")
#read file in and change structure of table to required format
forAnalysis <- protImportForAnalysis(inputFile)
##example plot:
g1D <- c("Q16540","P52815","P09001","Q13405","Q9H2W6") #group 1 data vector
g1N <- 'group1'                                        #group 1 name
g2D <- c("Q9NVS2","Q9NWU5","Q9NX20","Q9NYK5","Q9NZE8") #group 2 data vector
g2N <- 'group2'                                        #group 2 name
max_frac <- 23 
twoGroupsWithinLabelCoMigration(forAnalysis, max_frac, g1D, g1N, g2D, g2N)
}
