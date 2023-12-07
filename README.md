# Transposons_Exp_BLCA
A project on quantifying the expression level of TEs in bladder cancer tissue samples 


## Repository structure
- scripts: This directory contains scripts and notebooks.
- figs: Contains figures.
- datasets: Contains intermediate lightweight datasets.

Large files are hosted on OneDrive, and the following are the names and descriptions of files on OneDrive in the shared TE project directory:

```
├── data
│   ├── REdiscoverTE_results_tcga
|   ├── preProc_tcag_matrices
|   ├── RE_intergenic_4_loci_raw_counts.gz
|   ├── quant_files_tcga.tar.gz
│   └── r_objects
```


 ```REdiscoverTE_results_tcga```  contains the following files:

```
##File name: Description
GENE_1_raw_counts.RDS: raw counts DGEList data object.
GENE_2_counts_normalized.RDS: normalized counts (by total gene counts) DGEList data object.
GENE_3_TPM.RDS: TPM (transcripts per million) for each gene/transcript. DGEList data object.
RE_all_1_raw_counts.RDS: raw counts DGEList data object.
RE_all_2_counts_normalized.RDS: normalized by total gene counts
RE_all_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_exon_1_raw_counts.RDS: raw counts DGEList data object.
RE_exon_2_counts_normalized.RDS: counts are normalized by total gene counts
RE_exon_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_intron_1_raw_counts.RDS: raw counts DGEList data object.
RE_intron_2_counts_normalized.RDS: counts are normalized by total gene counts
RE_intron_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_intergenic_1_raw_counts.RDS: raw counts DGEList data object.
RE_intergenic_2_counts_normalized.RDS: counts are normalized by total gene counts
RE_intergenic_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
```

 ```preProc_tcag_matrices``` directory contains, the files that are similar to those in the ```REdiscoverTE_results_tcga``` and they are further preprocessed, so the column names have been changed to TCGA barcode and non-TE elements are dropped from the expression matrices. These files might be used as starting data for different tasks like normalization, DE, clustering, survival analysis, and .... 
 

```r_object``` contains, the following files:

*NB* : This directory will be updated regularly by adding more intermediate files.

```
## File name:  Description
id_map.RDS: A data frame is helpful to map file names to TCGA barcodes
clinical.RDS: A data frame on clinical features for participants in TCGA-BLCA
rmsk_annotation.RDS: The repeat masker annotation file, released from REdiscoverTE/UCSC
te.rmk.RDS:  A subset of rmsk_annotation.RDS, that retain data only on TE elements (LINE, SINE, LTR, DNA, and Retroposon)
master_gene_list.RDS: A compilation of different gene lists from KEGG, BIOCARTA ... InterPro, other studies like TCGA 2017, Combes et al and ...
surv_assoicated_tes_log2CPM.RDS : The log2CPM values of TEs significantly associated with OS
te_vst.RDS: A normalized and transformed (variance stabilizing transformation) expression matrix of intergenic TEs
data.gsva_3k_pathways.RDS : A dataframe on the result of running GSVA using the master gene list (> 3K pathways)
vst_normalized_all_gene_expMat_tcga.RDS: A normalized and transformed (variance stabilizing transformation) expression matrix of all genes in TCGA
```

```RE_intergenic_4_loci_raw_counts.gz``` This is an expression matrix of raw counts for intergenic TEs while the rowname inidcate the exact loci of the element. The rownames are in the following structure:
repName|repFamily|repClass|coordinate e.g:

'L1MB3|L1|LINE|2__104370544_104370587'

```quant_files_tcga.tar.gz``` sf files output from Salmon internally run by REdoscoverTE
