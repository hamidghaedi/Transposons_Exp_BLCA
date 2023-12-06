#!/bin/bash
# A script to split sf file into two subsets: zeroExp and nonZeroExp 


# Define paths
work_dir="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp"
sf_files_path="/home/ghaedi/projects/def-gooding-ab/ghaedi/quant_res_REdisc/" 

# Set up working directory
cd "$work_dir"

# Create necessary directories if they don't exist
mkdir -p nonZero_exp/all
mkdir -p zero_exp

# Get the total number of .sf files
total_files=$(ls -1 "$sf_files_path"*.sf | wc -l)
file_index=0

# Iterate through all .sf files in sf_file_path
for sf_file in "$sf_files_path"*.sf; do
    ((file_index++))

    # Extract the filename without extension
    file_basename=$(basename "$sf_file" .sf)

    # Print message indicating the current file being processed
    echo "Processing file $file_index/$total_files: $sf_file"

    # Perform steps for zero expression
    echo "Creating zero expression file..."
    awk '$NF == 0 || NR == 1' "$sf_file" > "zero_exp/${file_basename}_zeroExp.sf"

    # Perform steps for non-zero expression
    echo "Creating non-zero expression file..."
    awk '$NF > 0 || NR == 1' "$sf_file" > "nonZero_exp/all/${file_basename}_nonZeroExp.sf"

    # Print a newline for better readability
    echo
done

# Print a message indicating the completion of the script
echo "Processing completed!"
