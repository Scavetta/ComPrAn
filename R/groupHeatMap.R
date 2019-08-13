#' Make heatmap
#'
#' This function creates a heatmap for a subset of proteins in dataFrame specified in groupData,
#' heatmap is divided into facets according to isLabel
#'
#' @param dataFrame data frame, contains columns:
#'           `Protein Group Accessions` character
#'           `Protein Descriptions` character
#'            Fraction integer
#'            isLabel character ('TRUE'/'FALSE' values)
#'            `Precursor Area` double
#'            scenario character
#' @param groupData data frame, mandatory column: `Protein Group Accessions` character - this column is used for filtering
#'            optional columns: any other column of type character that should be used for renaming
#' @param groupName character, name that should be used for the group specified in groupData
#' @param titleAlign character, one of the 'left', 'center'/'centre', 'right', specifies alignment of the title in plot
#' @param newNamesCol character, if groupData contains column for re-naming and you want to use it, specify
#'              the column name in here
#' @param colNumber numeric, values of 1 or 2, specifies whether facets will be shown side-by-side or above each other
#' @param ylabel character
#' @param xlabel character
#' @param legendLabel character
#' @param grid logical, specifies presence/absence of gridline in the plot
#' @param labelled character, label to be used for isLabel == TRUE
#' @param unlabelled character, label to be used for isLabel == FALSE
#'
#' @return plot
#' @export
groupHeatMap <- function(dataFrame, groupData, groupName,
                         titleAlign = "left", newNamesCol = NULL, colNumber = 2,
                         ylabel = "Protein", xlabel = "Fraction",
                         legendLabel = "Relative Protein Abundance", grid = TRUE,
                         labelled = "labeled", unlabelled = "unlabeled") {


  #join DF and group data - proteins present in group but absent in the data will be shown as empty
  groupData %>%
    select(`Protein Group Accessions`, newNamesCol) -> groupData
  right_join(dataFrame, groupData) -> dataFrame

  if(sum(is.na(dataFrame$isLabel))>0){
    dataFrame[is.na(dataFrame$isLabel),]$isLabel <- FALSE}

  #rename proteins if such column is provided
  if(!is.null(newNamesCol)){
    ycolumn <- newNamesCol
  } else {
    ycolumn <- 'Protein Group Accessions'
  }

  #draw basic plot
  p <- ggplot(dataFrame, aes(x = Fraction, y = get(ycolumn), fill = `Precursor Area`)) +
    geom_raster(na.rm = T)  +
    facet_wrap(isLabel ~ ., ncol = colNumber, labeller = labeller(isLabel = c("TRUE" =  labelled,
                                                                              "FALSE" = unlabelled)))+
    labs(title = groupName) +
    ylab(ylabel) +
    xlab(xlabel) +
    scale_fill_gradient(legendLabel,low = '#cacde8',high = '#0019bf', na.value="grey60") +
    coord_cartesian(expand = 0)

  #add grid
  if(grid){
    p<- p +theme_minimal() +
      theme(panel.grid.minor = element_blank())
  } else {
    p<- p +theme_classic()
  }

  #title alignment settings
  if (titleAlign == 'left'){
    adjust <- 0
  } else if ((titleAlign == 'centre')|(titleAlign=='center')) {
    adjust <- 0.5
  } else if(titleAlign == 'right'){
    adjust <- 1
  }

  #adjust position of title
  p <- p + theme(plot.title = element_text(hjust = adjust))

  return(p)

}