#!/bin/bash
# A script to add loci to a nonZeroExp sf file 

# Set paths
exon_loci_file="/home/ghaedi/projects/def-gooding-ab/ghaedi/REdiscoverTE/te_exon_rmsk.tsv"
intron_loci_file="/home/ghaedi/projects/def-gooding-ab/ghaedi/REdiscoverTE/te_intron_rmsk.tsv"
intergenic_loci_file="/home/ghaedi/projects/def-gooding-ab/ghaedi/REdiscoverTE/te_intergenic_rmsk.tsv"
work_dir="/home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp/nonZero_exp"
exon_result_path="$work_dir/exonic"
intron_result_path="$work_dir/intronic"
intergenic_result_path="$work_dir/intergenic"
sf_file_path="$work_dir/all"

# Header
header="Name\tLength\tEffectiveLength\tTPM\tNumReads\tLociCount\trepName\trepClass\trepFamily\tLociType\tCoordinate"

# Get the total number of .sf files
total_files=$(ls -1 "$sf_file_path"/*.sf | wc -l)
file_index=0

# Loop through files
for sf_file in "$sf_file_path"/*.sf; do
    ((file_index++))
    # Extract file name
    file_basename=$(basename "$sf_file" .sf)

    # Print message indicating the current file being processed
    echo "Processing file $file_index/$total_files: $file_basename"

    # Sort the input files based on the join field
    sort -t $'\t' -k1,1 "$sf_file" -o "$sf_file"
    sort -t $'\t' -k1,1 "$exon_loci_file" -o "$exon_loci_file"
    sort -t $'\t' -k1,1 "$intron_loci_file" -o "$intron_loci_file"
    sort -t $'\t' -k1,1 "$intergenic_loci_file" -o "$intergenic_loci_file"

    # Left join using Name column in sf file and Md5 column in exon_loci_file
    echo "Performing exon loci left join..."
    join -t $'\t' -1 1 -2 1 "$sf_file" "$exon_loci_file" > "$exon_result_path/${file_basename}_exonLociExp.tsv"
    # Set header
    echo -e "$header" | cat - "$exon_result_path/${file_basename}_exonLociExp.tsv" > temp && mv temp "$exon_result_path/${file_basename}_exonLociExp.tsv"

    # Left join using Name column in sf file and Md5 column in intron_loci_file
    echo "Performing intron loci left join..."
    join -t $'\t' -1 1 -2 1 "$sf_file" "$intron_loci_file" > "$intron_result_path/${file_basename}_intronLociExp.tsv"
    # Set header
    echo -e "$header" | cat - "$intron_result_path/${file_basename}_intronLociExp.tsv" > temp && mv temp "$intron_result_path/${file_basename}_intronLociExp.tsv"

    # Left join using Name column in sf file and Md5 column in intergenic_loci_file
    echo "Performing intergenic loci left join..."
    join -t $'\t' -1 1 -2 1 "$sf_file" "$intergenic_loci_file" > "$intergenic_result_path/${file_basename}_intergenicLociExp.tsv"
    # Set header
    echo -e "$header" | cat - "$intergenic_result_path/${file_basename}_intergenicLociExp.tsv" > temp && mv temp "$intergenic_result_path/${file_basename}_intergenicLociExp.tsv"

    # Print a newline for better readability
    echo
done

# Print a message indicating the completion of the script
echo "Processing completed!"
