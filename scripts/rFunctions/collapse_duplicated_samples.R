collapse_duplicated_samples <- function(mtx){ # samples in columns
  tmp <- t(mtx)
  sample_ids <- substr(rownames(tmp),1,16)
  dup_ids <- sample_ids[duplicated(sample_ids) | duplicated(sample_ids, fromLast = TRUE)]
  if(length(dup_ids) == 0){
    message("There are no duplicated samples.")
    return(mtx)
  }else{
    cat("A total of", length(dup_ids),"duplicated samples identified. \n" )
    tmp_unik <- tmp[!(sample_ids %in% dup_ids),]
    tmp_dup <- data.frame(matrix(ncol = ncol(tmp_unik), nrow = 0))
    colnames(tmp_dup) <- colnames(tmp_unik)
    cat("Deduplication process has started.... \n" )
    for(id in dup_ids){
      id_idx <- which(sample_ids==id)
      tmp2 <- tmp[id_idx,]
      tmp_dup[rownames(tmp)[id_idx][1],] <- colMeans(tmp2)
    }
    tmp_res <- t(as.data.frame(rbind(tmp_unik, tmp_dup)))
    cat("...Done! \n")
    cat("The sample numbers dropped from", nrow(tmp), "to", ncol(tmp_res), ". \n" )
  }
  return(tmp_res)
}