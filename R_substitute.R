### Author: Zhou WU
### Date: 2023/02/22

KeyMatch<-read.table('Compare_chr_list',header=F)
#GC is the target file here

MAT_g<-function(x){
  if(x%in%KeyMatch$V1==T){as.character(KeyMatch[KeyMatch$V1==x,]$V2)}
  else {NA}}

m1 <- array(GC[,1,drop=T]) #array and matrix would work 
m2 <- matrix(sapply(m1,MAT_g,simplify = F))
m2 <- as.data.frame(m2)
m2$V1 <- as.character(m2$V1) #it seems to be theproblem with character
m2[m2 == "NA"] <- NA

m3 <- cbind(GC,m1,m2)
