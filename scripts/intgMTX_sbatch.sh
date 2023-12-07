#!/bin/bash
#SBATCH --job-name=intgMTX
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=0-5:00:00
#SBATCH --mem=80gb
#SBATCH --output=intgMTX.%J.out
#SBATCH --error=intgMTX.%J.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=qaedi.65@gmail.com


module load python
# activating python env
cd /home/ghaedi/projects/def-gooding-ab/ghaedi

source py_env/bin/activate

cd /home/ghaedi/projects/def-gooding-ab/ghaedi/loci_wise_TE_exp

# run script
python ./ntergenicMTX_maker.py
