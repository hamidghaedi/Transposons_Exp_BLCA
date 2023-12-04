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
│   └── r_objects
```

In  ```REdiscoverTE_results_tcga``` the following files are located:

```
## File name					            ## Description
GENE_1_raw_counts.RDS				      raw counts DGEList data object.
GENE_2_counts_normalized.RDS			normalized counts (by total gene counts) DGEList data object.
GENE_3_TPM.RDS					          TPM (transcripts per million) for each gene/transcript. DGEList data object.
RE_all_1_raw_counts.RDS    				raw counts DGEList data object.
RE_all_2_counts_normalized.RDS		normalized by total gene counts
RE_all_3_TPM.RDS				          TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_exon_1_raw_counts.RDS			    raw counts DGEList data object.
RE_exon_2_counts_normalized.RDS		counts are normalized by total gene counts
RE_exon_3_TPM.RDS				          TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_intron_1_raw_counts.RDS			  raw counts DGEList data object.
RE_intron_2_counts_normalized.RDS	counts are normalized by total gene counts
RE_intron_3_TPM.RDS				        TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
RE_intergenic_1_raw_counts.RDS		raw counts DGEList data object.
RE_intergenic_2_counts_normalized.RDS		counts are normalized by total gene counts
RE_intergenic_3_TPM.RDS				      TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.
```

In the ```preProc_tcag_matrices``` directory, the files are similar to those in the ```REdiscoverTE_results_tcga``` and they are further preprocessed, so the column names have been changed to TCGA barcode and non-TE elements are dropped from the expression matrices. These files might be used as starting data for different tasks like normalization, DE, clustering, survival analysis, and .... 

In the ```r_object``` , the following files are located :

```
## File name					## Description
id_map.RDS					  A data frame is helpful to map file names to TCGA barcodes
clinical.RDS					A data frame on clinical features for participants in TCGA-BLCA
rmsk_annotation.RDS		The repeat masker annotation file, released from REdiscoverTE/UCSC
te.rmk.RDS					  A subset of rmsk_annotation.RDS, that retain data only on TE elements (LINE, SINE, LTR, DNA, and Retroposon)
master_gene_list.RDS	A compilation of different gene lists from KEGG, BIOCARTA ... InterPro, other studies like TCGA 2017, Combes et al and ...	
```
