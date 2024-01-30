# function to inspect frequency of values
freq_inspect <- function(df, col, hist = FALSE, smry = TRUE, save=FALSE){
  tmp <- as.data.frame(unclass(table(df[, col])))
  r <- data.frame(variable = rownames(tmp), freq = tmp[,1])
  r <- r[order(r$freq, decreasing = T),]
  if (hist) {
    hist(res$freq, main = "Frequency Histogram", xlab = "Frequency", col = "skyblue", border = "black")
  }
  
  if (smry) {
    print(summary(r$freq))
  }
  if(save){
    return(r)
  }
  View(r)
}
