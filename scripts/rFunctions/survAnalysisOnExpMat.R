#' survAnalysisOnExpMat
#'
#' A function to perform survival analysis on an expression matrix. By default, the function uses MaxStat to identify the optimal cutpoint for gene expression values. It assigns 'low_exp' and 'high_exp' labels to samples based on that cutpoint.
#' Genes with only one level, either high_exp or low_exp, won't be processed for their effect on survival probability.
#'
#' @param expressionMatrix An expression matrix with genes in rows and samples in columns.
#' @param clinicalData A dataframe where the patients' IDs are in the "barcode" column.
#' @param timeColumn A character argument indicating a column that has time data.
#' @param eventColumn A character argument indicating a column filled with 0 (no event) and 1 (event). By default, it can convert values "Alive" and "Dead" to 0 and 1, as this is the default in TCGA BLCA metadata.
#'
#' @return A dataframe with genes, hazard ratio, p-value, and Bonferroni, Holm, Hochberg, and FDR adjusted p-values.
#' 


survAnalysisOnExpMat <- function(expressionMatrix, clinicalData, timeColumn, eventColumn, Is_TCGA = TRUE) {
  if (!requireNamespace("survminer", quietly = TRUE)) {
    install.packages("survminer")
  }
  library(survminer)
  
  if (!requireNamespace("SummarizedExperiment", quietly = TRUE)) {
    BiocManager::install("SummarizedExperiment")
  }
  library(SummarizedExperiment)
  
  # create se object
  # Convert the expression matrix to a SummarizedExperiment object
  expr_se <- SummarizedExperiment(assays = list(counts = as.matrix(expressionMatrix)),
                                  colData = DataFrame(clinicalData))
  if(Is_TCGA){
    # Check if clinical data has any non-tumor samples
    non_tumor_samples <- substr(rownames(colData(expr_se)), 14, 14) == "1"
    
    if (any(non_tumor_samples)) {
      message("There are non-tumor samples present in the clinical dataset; those will be removed from both clinical and expression matrix.")
      # Remove non-tumor samples
      filtered_expr_se <- expr_se[, !non_tumor_samples]
    }
    
    # extract elements
    # Extract colData from the filtered SummarizedExperiment
    clinicalData <- as.data.frame(colData(filtered_expr_se))
    # Extract the expression matrix from the filtered SummarizedExperiment
    expressionMatrix <- assays(filtered_expr_se)$counts
    
    if(nrow(clinicalData) != ncol(expressionMatrix)){
      stop("The number of samples in clinical data and expression matrix is not the same.")
    }
    
    # Creating survival data
    barcode = clinicalData$barcode
    if(all(clinicalData[[eventColumn]]) %in% c(0, 1)){
      event = as.numeric(clinicalData[[eventColumn]])
    } else {
      event = ifelse(clinicalData[[eventColumn]] == "Alive", 0,
                     ifelse(clinicalData[[eventColumn]] == "Dead", 1, NA))
    }
    
    
    time = as.numeric(clinicalData[[timeColumn]])
    survData <- data.frame(barcode = barcode, event = event, time = time)
    
    # Combined datasets
    # first transpose the expression matrix
    message("Processing expression matrix...")  
    expressionMatrix <- t(expressionMatrix)
    
    if (all(rownames(expressionMatrix) == survData$barcode)) {
      survData <- cbind(survData, expressionMatrix)
    } else {
      stop("The order of samples in expression matrix and clinical data are not matched")
    }
    # Determine the optimal cutpoint of variables
    message("Categorizing expression values into low and high expression ")  
    res.cut <- surv_cutpoint(survData, time = "time", event = "event",
                             variables = colnames(survData)[4:ncol(survData)])
    
    # Create a named vector
    cut_point <- setNames(sapply(colnames(expressionMatrix), function(te) res.cut[[te]]$estimate),
                          colnames(expressionMatrix))
    
    # Make expression values categorical
    for (i in 4:ncol(survData)) {
      te <- colnames(survData)[i]
      survData[, i] <- as.factor(ifelse(survData[, i] < cut_point[te], "low-exp", "high-exp"))
    }
    
    # Drop variables with just one level of data
    to_drop <- colnames(survData)[sapply(survData, function(x) length(unique(x)) < 2)]
    if(length(to_drop)!= 0){
      survData_filt1 <- survData[, -which(colnames(survData) %in% to_drop)]
    }else{
      survData_filt1 <- survData
    }
    
    # Dropping columns 
    survData_filt2 <- survData_filt1[, -which(colnames(survData_filt1) %in% c("barcode", "event", "time"))]
    
    # Perform survival analysis
    # Create a survival object using the 'Surv' function
    message("Performing survival analysis....")
    survival_data <- with(survData_filt1, Surv(time, event))
    
    # Fit Cox proportional hazards models for all variables
    cox_models <- lapply(names(survData_filt2), function(variable) {
      cox_model <- coxph(survival_data ~ survData_filt2[[variable]], data = survData_filt2)
      return(cox_model)
    })
    
    # Extract summary statistics for each model
    coxp_summaries <- lapply(cox_models, summary)
    names(coxp_summaries) <- colnames(survData_filt2)
    
    # Initialize an empty dataframe
    surv_summary <- data.frame(var_name = character(), Hazard_Ratio = numeric(), P_Value = numeric(), stringsAsFactors = FALSE)
    
    # Extract variable names, Hazard Ratios, and P-Values
    for (i in seq_along(coxp_summaries)) {
      variable_name <- names(coxp_summaries)[i]
      # Extract Hazard Ratio and P-Value
      coef_summary <- coxp_summaries[[i]]$coef
      hazard_ratio <- exp(coef_summary[1])  # Exponentiate the coefficient to get Hazard Ratio
      p_value <- coef_summary[5]            # Extract the P-Value
      # Append to the dataframe
      surv_summary <- rbind(surv_summary, data.frame(var_name = variable_name, Hazard_Ratio = hazard_ratio, P_Value = p_value))
    }
    
    # Adjust P-Values
    surv_summary$bonferroni.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'bonferroni')
    surv_summary$holm.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'holm')
    surv_summary$hochberg.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'hochberg')
    surv_summary$FDR <- p.adjust(surv_summary$P_Value, method = 'fdr')
    message("Done.")
    # Return the object
    return(surv_summary)
  }else
  {
    # for non TCGA expression matrix
    clinicalData <- as.data.frame(colData(expr_se))
    # Extract the expression matrix from the filtered SummarizedExperiment
    expressionMatrix <- assays(expr_se)$counts
    
    if(nrow(clinicalData) != ncol(expressionMatrix)){
      stop("The number of samples in clinical data and expression matrix is not the same.")
    }
    
    # Creating survival data
    barcode = clinicalData$barcode
    event = ifelse(!is.na(clinicalData[[eventColumn]]), as.numeric(clinicalData[[eventColumn]]), clinicalData[[eventColumn]])
    time = as.numeric(clinicalData[[timeColumn]])
    survData <- data.frame(barcode = barcode, event = event, time = time)
    # Combined datasets
    # first transpose the expression matrix
    message("Processing expression matrix...")  
    expressionMatrix <- t(expressionMatrix)
    
    if (all(rownames(expressionMatrix) == survData$barcode)) {
      survData <- cbind(survData, expressionMatrix)
    } else {
      stop("The order of samples in expression matrix and clinical data are not matched")
    }
    # Determine the optimal cutpoint of variables
    message("Categorizing expression values into low and high expression ")  
    # Create an empty list to store the results
    res.cut <- list()
    
    # Iterate over each column one at a time
    for (t in colnames(survData)[4:ncol(survData)]) {
      tryCatch({
        #cat("The variable being processed is", t, ".\n")
        res.cut[t] <- surv_cutpoint(survData, time = "time", event = "event", variables = t)
      }, error = function(e) {
        cat("Error processing the variable", t, ":", conditionMessage(e), "\n")
        res.cut[t] <- NULL
      })
    }
    
    
    # Make expression values categorical
    for (i in 4:ncol(survData)) {
      te <- colnames(survData)[i]
      survData[, i] <- as.factor(ifelse(survData[, i] < res.cut[[te]]$estimate, "low-exp", "high-exp"))
    }
    
    # Drop variables with just one level of data
    to_drop <- colnames(survData)[sapply(survData, function(x) length(unique(x)) < 2)]
    if(length(to_drop)!= 0){
      survData_filt1 <- survData[, -which(colnames(survData) %in% to_drop)]
    }else{
      survData_filt1 <- survData
    }
    
    # Dropping columns 
    survData_filt2 <- survData_filt1[, -which(colnames(survData_filt1) %in% c("barcode", "event", "time"))]
    
    # Perform survival analysis
    # Create a survival object using the 'Surv' function
    message("Performing survival analysis....")
    survival_data <- with(survData_filt1, Surv(time, event))
    
    # Fit Cox proportional hazards models for all variables
    cox_models <- lapply(names(survData_filt2), function(variable) {
      cox_model <- coxph(survival_data ~ survData_filt2[[variable]], data = survData_filt2)
      return(cox_model)
    })
    
    # Extract summary statistics for each model
    coxp_summaries <- lapply(cox_models, summary)
    names(coxp_summaries) <- colnames(survData_filt2)
    
    # Initialize an empty dataframe
    surv_summary <- data.frame(var_name = character(), Hazard_Ratio = numeric(), P_Value = numeric(), stringsAsFactors = FALSE)
    
    # Extract variable names, Hazard Ratios, and P-Values
    for (i in seq_along(coxp_summaries)) {
      variable_name <- names(coxp_summaries)[i]
      # Extract Hazard Ratio and P-Value
      coef_summary <- coxp_summaries[[i]]$coef
      hazard_ratio <- exp(coef_summary[1])  # Exponentiate the coefficient to get Hazard Ratio
      p_value <- coef_summary[5]            # Extract the P-Value
      # Append to the dataframe
      surv_summary <- rbind(surv_summary, data.frame(var_name = variable_name, Hazard_Ratio = hazard_ratio, P_Value = p_value))
    }
    
    # Adjust P-Values
    surv_summary$bonferroni.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'bonferroni')
    surv_summary$holm.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'holm')
    surv_summary$hochberg.Adj.Pval <- p.adjust(surv_summary$P_Value, method = 'hochberg')
    surv_summary$FDR <- p.adjust(surv_summary$P_Value, method = 'fdr')
    message("Done.")
    # Return the object
    return(surv_summary)
  }
}