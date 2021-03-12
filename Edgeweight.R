######################################Script for calculating edge weights of interactions between proteins###############################################3

#Input files: 1) File with nodes and node weights, 2) File with interations between nodes
#Output file: File with interacting nodes and corresponding edge weights

#Edge weight calculation: 1/sqrt(node weight 1* node weight 2)
#Node weight calculation: Fold change value of the node in a given condition* signal intensity of the node in the condition 

#list the node weight files as files<- list.files()
#then run with source("finaledgeweight.R")


#Read the interaction and nodeweight files into R
int<- read.delim("Interactions_HPPIN.txt", header = TRUE, sep="\t", stringsAsFactors = FALSE)

#loop over each files
for (i in (1: length(files))){
  args2<- files[i]
  nwt<- read.delim(args2, header = FALSE, sep=",", stringsAsFactors = FALSE)
  #Select only the interactionf for which both genes are present in node weights file
  int_i <-  (int$NodeA %in% nwt$V1) & (int$NodeB %in% nwt$V1)
  sub_int <- int[int_i,]
  sub_int <- sub_int[order(sub_int$NodeA, sub_int$NodeB),]
  
  #match node wts for the edges
  nodeAwts <- as.numeric(nwt$V2[match(sub_int$NodeA, nwt$V1)])
  nodeBwts <- as.numeric(nwt$V2[match(sub_int$NodeB, nwt$V1)])
  
  #calculate edgewt
  ewts <- 1/(sqrt(nodeAwts * nodeBwts))
  ew_new <- data.frame(sub_int, ewts, stringsAsFactors=F)

  
  #write the file
  write.table(ew_new, file=paste(args2,"_edgwt.txt", sep=""), append = TRUE, sep="\t", col.names = FALSE, quote = FALSE,  eol = "\n", na = "NA", dec = ".", row.names = FALSE)
}
  
