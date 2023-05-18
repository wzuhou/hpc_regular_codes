#!/bin/Rscript

ord=eval(parse(text = a))
#using variable in data name
clfile=eval(parse(text = paste0("cl",i)))

#Join files
plyr::test.1<-join(nrDEG,df,by="Gene",type="inner",match="all")
