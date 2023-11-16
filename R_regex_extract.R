### R
library(stringr)
#"ABC-110NWCS-33" "ABC-110-NWCS-28"
#extract the last numberas individual IID(maximum 3 digits)
str_extract(Sum2$ID, "\\d{1,3}$") 
