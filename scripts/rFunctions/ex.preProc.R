#' ex.preProc
#'
#' A function to pre-process an expression matrix. It drops non-TE elements and sets the expression matrix column names to TCGA barcode.
#'
#' @param mtx An expression matrix with repeat masker elements/genes in rows and samples in columns.
#' @param is_TE A logical argument. If "TRUE," it indicates that the matrix is a TE expression matrix.
#'
#' @return An expression matrix where genes are in rows, and samples are in columns.
#'
#' @seealso Use this function in conjunction with the "TErepName" and "id_map" objects.
#'



ex.preProc <- function(mtx, is_TE) {
  # 
  # mtx:  an expression matrix
  # is_TE: a logical argument , if TE exp mtx is passing, set this to TRUE
  # setting
  if (is_TE) {
    # step 1 dropping non TE elements
    tmp <- mtx[rownames(mtx) %in% TErepName, ]
    # print the number of TE elements retained in the matrix.
    cat("The number of retained TEs in the matrix is ", nrow(tmp), "\n")
    # step 2 setting the column names to TCGA barcode
    matched_id <- match(colnames(tmp), id_map$shortFileName)
    
    if (length(matched_id) == ncol(tmp)) {
      colnames(tmp) <- id_map$cases[matched_id]
      cat("All column names in the expression matrix have a match in ID map file \n")
    }
    
    if (length(match(colnames(tmp), id_map$shortFileName)) != ncol(tmp)) {
      cat("Not all columns in the expression matrix have a match in ID map file \n")
      no_match <- id_map$cases[which(!matched_id)]
      cat("See below for non-match columns:\n")
      cat(no_match)
    }
  } 
  else {
    # the matrix is a gene expression matrix and it needs just column names to be matched to TCGA barcode
    tmp <- mtx
    matched_id <- match(colnames(mtx), id_map$shortFileName)
    
    if (length(matched_id) == ncol(mtx)) {
      colnames(tmp) <- id_map$cases[matched_id]
      cat("All column names in the expression matrix have a match in ID map file \n")
    }
    
    if (length(match(colnames(mtx), id_map$shortFileName)) != ncol(mtx)) {
      cat("Not all columns in the expression matrix have a match in ID map file \n")
      no_match <- id_map$cases[which(!matched_id)]
      cat("See below for non-match columns:\n")
      cat(no_match)
    }
  }
  return(tmp)
}
