# Assuming interg_tes is a DataFrame and els is defined elsewhere
import os
import pandas as pd

# setting dirs
input_dir = "/home/ghaedi/projects/def-gooding-ab/ghaedi/quant_res_REdisc"
output_file = "interg_tes.tsv"

# setting variables 
print(f"reading intergenic repeatmakser annotation file")
intergenic_rmsk = pd.read_csv("/home/ghaedi/projects/def-gooding-ab/ghaedi/REdiscoverTE/te_intergenic_rmsk.tsv", sep="\t")
column_names = ['Name', 'LociNumber', 'RepName', 'RepClass', 'repFamily', 'LocusType', "Coordinates"]
intergenic_rmsk.columns = column_names

# tmp is reading the first file and storing the Name column in a variable
print(f"Exctracting intergenic TE element names ")
tmp=pd.read_csv("/home/ghaedi/projects/def-gooding-ab/ghaedi/quant_res_REdisc/083a1d65-1bca-414e-8193-92670662e47f_gdc_realn_rehead.sf", sep="\t")
tmp_filt = tmp[tmp['Name'].isin(intergenic_rmsk['Name'])]
els = tmp_filt['Name']



# Initialize an empty DataFrame to store results
final_df = pd.DataFrame()

# Iterate through files in the input directory
for file_number, filename in enumerate(os.listdir(input_dir), start=1):
    # Check if the file has a ".sf" extension
    if filename.endswith(".sf"):
        # Construct the full path to the file
        file_path = os.path.join(input_dir, filename)

        # Print the file number being processed
        print(f"Processing File {file_number}: {filename}")

        # Read the file into a DataFrame
        df = pd.read_csv(file_path, sep="\t")

        # Filter the DataFrame to retain intergenic elements
        filtered_df = df[df['Name'].isin(intergenic_rmsk['Name'])]

        # Test if the 'Name' column in filtered_df is equal to els
        if filtered_df['Name'].equals(els):
            # If yes, add the 'NumReads' column from filtered_df to the final DataFrame
            final_df[filename] = filtered_df['NumReads']
        else:
            # If not, print a message indicating the file name and condition
            print(f"Skipping {filename}. 'Name' column does not match with rest of files.")

# Set the row names of final_df to els
final_df.index=list(els)
# Drop rows where all columns are 0
final_df = final_df.loc[~(final_df == 0).all(axis=1)]

# Write the final DataFrame to a TSV file
print(f"Start writing output to disk")
final_df.to_csv(output_file, sep="\t", index=True)
print(f"DONE!")
