#!/bin/bash
# A script to create a project level matrix out of many  

# Define the directory containing the input files
input_dir="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp/temp"

# Define the output file
output_file="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp/joined_output.tsv"

# Initialize the output file with the header
echo -e "Name\t${input_dir}" > "$output_file"

# Loop through all files in the input directory
file_count=0
for file in "$input_dir"/*; do
    ((file_count++))

    # Get the base name of the file (excluding extension)
    base_name=$(basename "$file")

    # Perform an outer join and append to the output file
    join -t $'\t' -a 1 -a 2 -e '' -o 0,1.2,2.2 "$output_file" "$file" > "${output_file}.tmp"

    # Move the temporary file to the output file
    mv "${output_file}.tmp" "$output_file"

    # Print a message indicating the join process for each file
    echo "Joined file $file_count: $base_name"
done

# Print a completion message
echo "Joining completed. The output is saved in '$output_file'."
