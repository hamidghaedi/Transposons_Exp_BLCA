#!/bin/bash

# Define paths
work_dir="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp"
mtx_files_path="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp/nonZero_exp/pre_mtx"

# Check if the temp directory exists in the script's directory
 cd $work_dir

temp_dir="$work_dir/temp"

if [ ! -d "$temp_dir" ]; then
    # Create the temp directory if it doesn't exist
    mkdir "$temp_dir"
fi


# Loop through all loci_mtx.tsv files in the current directory
for file in "$mtx_files_path"/*loci_mtx.tsv; do
    # Get the base name of the file (excluding extension)
    base_name=$(basename "$file" .loci_mtx.tsv)

    # Rename the count column to the base name
    awk -v OFS='\t' -v new_name="$base_name" '{ $2 = new_name } 1' "$file" > "$temp_dir/${base_name}_renamed_loci_mtx.tsv"

    # Print a message indicating the renaming process for each file
    echo "Renamed count column in $file to $base_name"
done

# Print a completion message
echo "Renaming completed. Renamed matrices are saved in the '$temp_dir' directory."
