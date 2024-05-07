# Install the package, only need for 1st time using
#install.packages("qPCRtools")
#load the package
library('qPCRtools')
library('dplyr')

## setting your working path, in windows, double '\'
setwd("./Project_collaborate\\Kasia")

##################
#1. Input files
##################
cq.table = data.table::fread('K_cq_2.txt') #Column names: Position  Cq
design.table = data.table::fread('K_design_2.txt') #Column names: Position  Gene  Group BioRep
#Your input structure
cat(paste0('Input cq table:\n','\t',nrow(cq.table), ' rows \n','Input design table:\n ','\t',nrow(design.table), ' rows \n','\t',length(unique(design.table$Gene)) ,' genes\n', '\t',length(unique(design.table$Group)), ' groups'))

##################
#2. How you would want to sort your x axis
##################
unique(design.table$Group)
Grouporder<-c("Native",'Mock',"Scram", "Ex1","Ex4","Ex8","P1","P2")
unique(design.table$timepoint)
Myorder<-c("5h","12h","18h","24h","48h","72h" )
##################
#3. code for comparing and plotting
##################
source('./K_CalExp2ddCt_timepoint.R') #load the function
MyCalExp2ddCt(cq.table,
            design.table,
            ref.gene = "G",
            ref.group = "Mock",
            stat.method = "t.test",
            fig.type = "bar",
            Myorder=Myorder,
            Grouporder=Grouporder,
            fig.nrow = 1) -> res

##################
#4. show and save the table
##################
res[["table"]] %>% 
 # dplyr::slice(1:6) %>% 
  kableExtra::kable(format = "html") %>% 
  kableExtra::kable_styling("striped")
#and save as the name below
OutTable='qPCR_result.csv'
write.csv(res[["table"]],OutTable,row.names = F)

#5.show and save the plot 
res[["figure"]]
# save as the name below
PlotName='qPCR_plot_2.png'
ggsave(paste0('./',PlotName),res[["figure"]],dpi = 300,width = 20,height = 5)

#End#

