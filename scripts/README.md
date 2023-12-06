Scripts, notebooks and codes sharing directory 



#### Dependency map of creating an expression matrix with loci info

 1. To split sf file into zeroExp and nonZeroExp (split_sf.sh)
 2. To create loci-wise expression matrix per sample (mtx_preProc.R), From here onward, ONLY INTERGENIC matrix was processing
 3. To  rename count column and set that to file name (rename_mtx_bash.sh) 
 4. To create a project level matrix out of many(manyMTX2One.sh)
