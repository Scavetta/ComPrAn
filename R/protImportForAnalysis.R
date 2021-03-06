#' Modify import protein data
#' 
#' This function converts imported protien table into format compatible with 
#' downstream analysis
#' Imported file needs to contain following columns:
#' \itemize{
#' \item "Protein Group Accessions" - character/factor
#' \item "Protein Descriptions" - character
#' \item "scenario" - character/factor
#' \item "label" - logical
#' \item  columns "1" to "n" - numeric
#'}
#' 
#' @param inputFile - character vector containing the location of protein file
#' 
#' @export
#' 
#' @return data frame
#' @examples
#' 
#' ##Use example normalised proteins file
#' inputFile <- system.file("extData", "dataNormProts.txt", package = "ComPrAn")
#' #read file in and change structure of table to required format
#' forAnalysis <- protImportForAnalysis(inputFile)
#' 
protImportForAnalysis <- function(inputFile){
    .data <- data.table::fread(inputFile, stringsAsFactors = FALSE)
    .data %>%  gather(Fraction, `Precursor Area`, 
                        -c(`Protein Group Accessions`, `Protein Descriptions`, 
                        scenario, label)) %>%
        rename("isLabel" = "label") %>%
        select( `Protein Group Accessions`, `Protein Descriptions`, Fraction, 
                isLabel, `Precursor Area`, scenario) %>% 
        mutate(`Precursor Area` = na_if(`Precursor Area`, 0)) %>%
        mutate( isLabel = as.character(isLabel),
                Fraction = as.integer(Fraction)) -> .data
    return(.data)
}