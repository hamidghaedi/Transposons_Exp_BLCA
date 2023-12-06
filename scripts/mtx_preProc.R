#!/usr/bin/env Rscript

# A script to create loci-wise expression matrix using outputs of  assignLoci2nonZeroExp_sf.sh   

library(dplyr)
library(tidyr)

# Capture command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Extracting arguments
input_dir <- args[1]
output_dir <- args[2]

# Get the list of all files in the input directory
input_files <- list.files(path = input_dir, pattern = "\\.tsv$", full.names = TRUE)

# Print information about the input directory and number of files found
cat("Input directory:", input_dir, "\n")
cat("Number of files found:", length(input_files), "\n")

# Initialize mtx outside of the loop
mtx <- data.frame(Name = character(0), count = numeric(0))

# Loop over each file in the input directory
for (file_path in input_files) {
  # Extract the file name without the path
  file_name <- basename(file_path)

  # Print progress message
  cat("Processing file:", file_name, "\n")

  # Read the input file
  exp <- read.table(file_path, header = TRUE, sep = "\t")

  # Dropping rows where exp$LociCount > round(exp$NumReads)
  exp <- exp[-which(exp$LociCount > round(exp$NumReads)), ]

  # Initialize vectors for unique loci
  read_counts_1L <- c()
  unique_name_1L <- c()

  # Make a subset for unique loci
  tmp_1L <- exp[exp$LociCount == 1, ]
  unique_name_1L <- paste0(tmp_1L$repName, "_", tmp_1L$repFamily, "_", tmp_1L$repClass, ".", tmp_1L$Coordinate)
  read_counts_1L <- tmp_1L$NumReads

  # Initialize vectors for multi loci
  read_counts_ML <- c()
  unique_name_ML <- c()

  # Make a subset for multi loci
  tmp_ML <- exp[exp$LociCount > 1, ] %>%
    separate_rows(Coordinate, sep = ",") %>%
    mutate(spl_count = NumReads / LociCount)

  read_counts_ML <- tmp_ML$spl_count
  unique_name_ML <- paste0(tmp_ML$repName, "_", tmp_ML$repFamily, "_", tmp_ML$repClass, ".", tmp_ML$Coordinate)

  # Combine the results into a data frame
  mtx <- rbind(mtx, data.frame(Name = c(unique_name_1L, unique_name_ML),
                                count = c(read_counts_1L, read_counts_ML)))

  # Write the result to a TSV file in the specified output directory
  output_file <- file.path(output_dir, paste0(substr(file_name, 1, 36), "_loci_mtx.tsv"))
  write.table(mtx, output_file,
              col.names = TRUE, sep = "\t", quote = FALSE, row.names = FALSE)

  # Print completion message for the current file
  cat("Processing completed. Output written to:", output_file, "\n")
}

# Print completion message for all files
cat("Processing for all files completed.\n")
