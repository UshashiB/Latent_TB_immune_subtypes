library(tidyr)

#mention which node number cutoff to use
args = commandArgs(trailingOnly=TRUE)

dir.create(paste("Top", args[1], "_Nodes", sep=""))
dir.create(paste("Top", args[1], "_NodesPaths", sep=""))
dir.create(paste("Top", args[1], "_NodesNetwork", sep=""))

#list the files in directory
files<-list.files(pattern="Top_")


for(i in (1:length(files))){
  #print the working files name
  print(files[i])
  
  file<- read.csv(files[i], sep="\t", header=FALSE)
  
  #sort the file in increasing order of normalized path score
  file<- file[order(file$V4), ]
  
  #get only the paths portion from the files
  file$V1<- NULL
  file$V2<- NULL
  file$V3<- NULL
  file$V4<- NULL
  file$V5<- NULL
  
  #Find the number of paths which cover top target number of nodes  
  b<- {}
  for (j in (1:nrow(file))){
    if(length(b)<=as.numeric(args[1])){
      a<- as.character(file[j,])
      a<- unlist(strsplit(a, ","))
      b<- append(b, a)
      b<- unique(b)
      c<- j
    }
  }
  
  #b is the top nodes
  b<- data.frame(b)
  write.csv(b, paste("Top", args[1], "_Nodes/Top", args[1], "_Nodes_in_", files[i], sep=""), quote = FALSE, row.names = FALSE)
  
  #filter the top paths with top nodes
  file<- data.frame(file[1:c,])
  colnames(file)<- "Paths"
  write.csv(file, paste("Top", args[1], "_NodesPaths/Paths_with_Top", args[1], "_Nodes_", files[i], sep=""), quote = FALSE, row.names = FALSE)
  
  ### Convert the top paths into nodes
  
  #Separate the nodes in each path into columns
  pathways<- file %>% separate('Paths', c(paste0("V",seq_len(10))), sep=",")
  
  #Create two empty dataframes of two columns 
  df1<-data.frame(matrix(ncol=2))
  colnames(df1)<- c("Node1", "Node2")
  df2<-data.frame(matrix(ncol=2))
  
  #breakdown the pathways table in sets of two consecutive columns
  cols<-ncol(pathways)
  
  for (k in (1:cols)){
    if(k!=cols){
      df2<- pathways[,k:(k+1)]
      colnames(df2)<- c("Node1", "Node2")
      df1<- rbind(df1, df2)
    }
  }
  
  #remove all the rows with NA
  final_all_nodes<-na.omit(df1)
  
  #remove the blank spaces
  final_all_nodes <- final_all_nodes[!(final_all_nodes$Node1 == ""), ]
  final_all_nodes <- final_all_nodes[!(final_all_nodes$Node2 == ""), ]
  
  #choose only the unique nodes to remove the duplicate edges
  final_all_nodes<-unique(final_all_nodes)
  
  #write the network file
  write.table(final_all_nodes, paste("Top", args[1], "_NodesNetwork/Top",args[1],"_nodes_",files[i],"_network.csv", sep=""), col.names =TRUE, row=FALSE, sep=",", quote=FALSE)
}
