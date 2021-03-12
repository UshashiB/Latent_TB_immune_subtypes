# Latent_TB_immune_subtypes

<b> Minimum requirements </b>

* Linux system with minimum 8GB of RAM and 20GB of storage space
* Python (v-2.7) & Python dependencies: zen, numpy, cython
* R (>= 3.4) and Bioconductor

<b> Steps for analysis </b>

1) Create node weight files with 2 comma separated columns with headers "Gene" and "NodeWt"

2) Compute edge weights using the Edgeweight.R code and HPPIN.txt file

3) Calculate top perturbed networks using the following:

> python2.7 shortest_path.py edgeweightFileName 3 # 3 stands for minimum path length

> ./top50K.sh ShortestPathOutputFile #sorts all path by pathscore and outputs top 50K paths

> Rscript Top_Perturbed_network.R 500  # 500 for the number of top nodes, this script runs for all the sorted top paths file at once

4) Use InnateDB (https://www.innatedb.com/redirect.do?go=batchPw) for pathway overepresentation analysis.

5) For binary scoring of enriched pathways and Consensus Clustering use binaryScoring_ConsensusClustering.R with IPLTB.csv and critical_genes.csv files
