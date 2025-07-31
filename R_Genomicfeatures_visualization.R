#BiocManager::install("Gviz")
#BiocManager::install("txdbmaker")
library(data.table)
library('RMariaDB')
library("Gviz")
suppressPackageStartupMessages(library('GenomicFeatures'))
txdbmaker::supportedUCSCtables(genome="galGal6")#Check what info to use#supportedUCSCtables(genome="mm9")
gal5_txdb <- txdbmaker::makeTxDbFromUCSC(genome="galGal6", tablename="ensGene")## tablename="ensGene"
txdb<-gal5_txdb
head(seqlevels(txdb))
seqlevels(txdb) <- "chr28"
#filtering
#data(geneModels) #exaples file
columns(txdb)
keytypes(txdb)
cols=c("EXONCHROM","EXONEND","EXONID", "EXONRANK", "EXONSTART" ,"EXONSTRAND","TXNAME","TXID","GENEID", "EXONID" )
keys=c( "ENSGALT00000068365.3")
GeneModels <- select(txdb, keys = keys, columns=cols, keytype="TXNAME")
names(GeneModels) <- c("transcript","Exon","chromosome","strand","start","end","gene","ID","ExonRank")
GeneModels$gene="ACSBG2"
#Gene<-genes(txdb)
####OR:
# GR <- transcripts(txdb)
# dt <- as.data.table(GR)
# GR <- transcripts(txdb, use.names=TRUE)
# geneModels<-GeneRegionTrack(GR)
#
ideoTrack <- IdeogramTrack(genome = "galGal6", chromosome = "chr28")
#plotTracks(ideoTrack, from = 1746737, to = 1763012) #1746737-1763012
#
axisTrack <- GenomeAxisTrack(range = IRanges(start = c(1746737), end = c(1763012), names = rep("N-stretch",1)))
#plotTracks(axisTrack, from = 1e+06, to = 2e+06)

grtrack <- GeneRegionTrack(GeneModels,genome ="galGal6" ,name = "Genes",chromosome = "chr28",fontsize=20,cex.group=1.5)
#plotTracks(grtrack,from = 1746737, to = 1763012,transcriptAnnotation = "transcript")

aTrack <- AnnotationTrack(start = c(1751075,1761021),end=c(1751115,1761061),
                          chromosome = "chr28", 
                          strand = c("*", "*"),
                          id = c("AFW QTL1(24371)", "AFW QTL1(24370)"), 
                          genome = "galGal6", name = "QTL",fill="#2840b8",col="#2840b8",fontsize=20,cex.group=1.1)

#displayPars(grtrack) <- list(background.panel = "#FFFEDB", col = NULL)
plotTracks(list(ideoTrack,axisTrack,grtrack,aTrack),from = 1740000, to = 1770000,transcriptAnnotation="gene",groupAnnotation = "id",col.line = "black",just.group = "left")

pdf('./test.pdf',width=10,height=3.5)
plotTracks(list(ideoTrack,axisTrack,grtrack,aTrack),from = 1745000, to = 1768000,transcriptAnnotation="gene",groupAnnotation = "id",col.line = "black",just.group = "left")
#without ideo track
#plotTracks(list(axisTrack,grtrack,aTrack),from = 1745000, to = 1768000,transcriptAnnotation="gene",groupAnnotation = "id",col.line = "black",just.group = "left")
dev.off()
#########################
head(gene(grtrack))
head(transcript(grtrack))
head(exon(grtrack))
head(symbol(grtrack))
#END#
