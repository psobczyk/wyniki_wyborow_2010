trim <- function( x ) {
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}
kody <- read.csv("kody_GUS.csv", header=F)
prev <- "http://wybory2014.pkw.gov.pl/pl/wyniki/gminy/view/"
zlacz <- function(x){
  s = ""
  if(x[1]<10){
    s = paste0(s, "0", trim(x[1]), collapse="")
  } else {
    s = paste0(s, x[1], collapse="") 
  }
  if(x[2]<10){
    s = paste0(s, "0", trim(x[2]), collapse="")
  } else {
    s = paste0(s, x[2], collapse="") 
  }
  if(x[3]<10){
    s = paste0(s, "0", trim(x[3]), collapse="")
  } else {
    s = paste0(s, x[3], collapse="") 
  }
  return(s)
}
write.table(unique(apply(kody[,1:4], 1, function(x) paste0(prev, zlacz(x), collapse=""))), "gminy_adresy", row.names=FALSE, quote=F)
write.table(unique(apply(kody[,1:4], 1, zlacz)), "gminy_kody", row.names=FALSE, quote=F)