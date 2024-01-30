#' correlateMatrix
#'
#' A function to calculate the Pearson correlation between columns of two data frames with the same number and order of rows, returning the correlation coefficient, p-value, and false discovery rate (FDR).
#'
#' @param df1 The first dataframe.
#' @param df2 The second dataframe.
#' @param show_progress Logical argument (TRUE is the default).
#'
#' @return A dataframe with five columns including the pair of variables, correlation coefficient, p-value, and FDR.
#'

correlateMatrix <- function(df1, df2, show_progress = TRUE) {

  # Check if data frames have the same number of rows
  if (nrow(df1) != nrow(df2)) {
    stop("Data frames must have the same number of rows.")
  }
  
  # Create a progress bar
  pb <- NULL
  if (show_progress) {
    pb <- progress_bar$new(
      format = "[:bar] :percent Elapsed: :elapsed ETA: :eta",
      total = ncol(df1) * ncol(df2)
    )
  }
  
  # Preallocate result data frame
  result_df <- data.frame(
    var1 = character(),
    var2 = character(),
    correlation_coefficient = numeric(),
    p_value = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Calculate correlation and extract statistics
  for (i in 1:ncol(df1)) {
    for (j in 1:ncol(df2)) {
      # Extract the columns
      x <- df1[, i]
      y <- df2[, j]
      
      # Calculate the correlation
      correlation_result <- cor.test(x, y)
      
      # Extract the correlation coefficient and p-value
      correlation_coefficient <- correlation_result$estimate
      p_value <- correlation_result$p.value
      
      # Store the results directly in the preallocated data frame
      result_df <- rbind(result_df, list(
        var1 = colnames(df1)[i],
        var2 = colnames(df2)[j],
        correlation_coefficient = correlation_coefficient,
        p_value = p_value
      ))
      
      # Increment the progress bar
      if (show_progress) pb$tick()
    }
  }
  
  # Add FDR to the result table
  result_df$FDR <- p.adjust(result_df$p_value, method = "fdr")
  # sort
  result_df <- result_df[order(abs(result_df$correlation_coefficient), decreasing = T),]
  
  # Return result
  return(result_df)
}
