args     <- commandArgs(trailingOnly = TRUE)
wyborcow <- as.numeric(gsub(" ", "", args[1]))
wydanych <- as.numeric(args[2])
waznych  <- as.numeric(args[3])
miejsce  <- args[4:length(args)]
miejsce  <- paste0(miejsce, collapse="_")

komitet  <- c("Liczba wyborców", "Liczba kart oddanych", "Liczba głosów ważnych")
procent  <- c(wyborcow, wydanych, waznych)
d <- data.frame(komitet, procent)
#print(d)
komitety <- read.csv("kom.csv", header=F)
glosy <- read.csv("glos.csv", header=F)

dane <- cbind(komitety, glosy)
colnames(dane) <- c("komitet", "procent")
dane <- rbind(d, dane)

#musimy usunąć znak specjalny /, występuje w adresach niektórych lokali wyborczych
miejsce <- gsub("/", "", miejsce)
filename <- paste0("wyniki/", miejsce, ".csv")
write.csv(dane, filename)
