library(ConsensusClusterPlus)
library(pvclust)

targetPaths<- read.csv('IPLTB.csv')
criticalGenes<- read.csv('critical_genes.csv')

#Save all InnateDB enrichment results from the webserver as .txt (tab separated) files
files<- list.files(pattern="InnateDB") #list all innateDB ORA results

PS<- data.frame(matrix(nrow=nrow(targetPaths), ncol = length(files)+1))
PS$X1<- targetPaths$Pathway.Name
colnames(PS)<- c('Pathways', files)
colnames(PS)<- gsub(".txt", "", colnames(PS))


for(i in 1:length(files)){
  sample<- files[i]
  data<- read.csv(sample, sep="\t")
  data$log10P<- -1*(log10(data$Pathway.p.value..corrected.))
  data<- subset(data, data$Pathway.Name %in% targetPaths$Pathway.Name)
  
  ## check if ligand or receptor genes are present
  dataFinal<- data.frame()
  for (p in 1:nrow(data)){
    testpath<- data[p,1]
    pathgenes<- as.character(criticalGenes[grep(testpath,criticalGenes$Pathway.Name), 2])
    pathgenes<- strsplit(pathgenes, ";")
    pathgenes<- data.frame(pathgenes[[1]])
    
    datagenes<- as.character(data$Gene.Symbols[p])
    datagenes<- strsplit(datagenes, ";")
    datagenes<- data.frame(datagenes[[1]])
    datagenes$datagenes..1..<- gsub(" ", "", datagenes$datagenes..1..)
    
    if(any(datagenes$datagenes..1.. %in% pathgenes$pathgenes..1..) == TRUE){
      dataFinal<- rbind(dataFinal, data[p,])
    }
  }  
  dataFinal<- subset(dataFinal, dataFinal$log10P >= 5) #modify cutoff as suitable
  for(j in 1:nrow(PS)){
    if(PS[j,1] %in% dataFinal$Pathway.Name){
      PS[j, i+1]<- 1
    }
    else {
      PS[j, i+1]<- 0
    }
  }
}


PS2<- PS
PS2$Pathways<- NULL

#consensus clustering
results<- ConsensusClusterPlus(as.matrix(PS2),maxK=15,reps=1000,pItem=0.8,pFeature=1, 
                               clusterAlg="hc",distance="pearson",seed=123456,plot="png")

icl = calcICL(results,plot="png")
dend<- results[[8]][["consensusTree"]]
dend[["labels"]]<- colnames(PS2)
plot(dend)


