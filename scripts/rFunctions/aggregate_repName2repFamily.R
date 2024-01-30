#' aggregate_repName2repFamily
#'
#' A function to aggregate TE expression at the Family level by taking the mean.
#'
#' @param expressionMatrix A TE expression matrix at repName level.
#' @param te_rmk The name of the RepeatMasker object in the global environment, which will be used to map between repName and repFamily levels.
#'
#' @return An expression matrix summarized at the repFamily level.
#'

aggregate_repName2repFamily <- function(expressionMatrix, te_rmk) {
  
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr")
  }
  library(dplyr)
  
  tmp <- data.frame(expressionMatrix)
  
  if (exists("te_rmk")) {
    rmk_tmp <- unique(te_rmk[, c("repName", "repFamily")][te_rmk$repName %in% rownames(tmp), ])
    tmp$repName <- rownames(tmp)
    tmp <- left_join(tmp, rmk_tmp, by = "repName")
    
    expMat <- tmp[, !colnames(tmp) %in% c("repName")] %>%
      group_by(repFamily) %>%
      summarise_all(mean) %>%
      data.frame()
    
    rownames(expMat) <- expMat$repFamily
    expMat <- expMat[, -1]
    colnames(expMat) <- gsub('[.]', "-", colnames(expMat))
    
    return(expMat)
  } else {
    stop("TE repeat masker annotation file 'te_rmk' is not available.")
  }
}
