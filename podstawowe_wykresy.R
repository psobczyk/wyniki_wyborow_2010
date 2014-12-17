#' 
#' Piotr Sobczyk 
#' 

library(ggplot2)
dane <- read.csv("wyniki_mazowsze.csv")

#Ze względu na klarowność wykresu bierzemy pod uwagę tylko
#4 największe partie
wazne <- c(10,11,13,14)
hist.data <- data.frame(partia = factor(rep(colnames(dane)[wazne], each = nrow(dane))))
#brzydki fragment, do przepisania
results <- NULL
for(j in wazne) {
  results <- c(results, dane[,j])
}
hist.data[["wynik"]] <- results

# Histogramy poparcia dla partii
for(party in colnames(dane)[wazne]){
  filename <- paste0("wyniki_", party, 
                     "_mazowsze_2010_lokale_zbiorcze.pdf")
  pdf(filename)
  print(qplot(dane[[party]], binwidth=.5, alpha=.7) + 
          xlab("Poparcie w %") +
          ylab("Liczba lokali wyborczych") +
          theme(legend.position="none") +
          ggtitle(paste0("Wynik ", party, 
                         " w wyborów samorzadowych 2010 na Mazowszu")))
  dev.off()
}

pdf("wyniki_mazowsze_2010_lokale_zbiorcze.pdf")
ggplot(hist.data, aes(x=wynik, fill=partia)) + 
  geom_density(alpha=.3, kernel="gau") +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2010 na Mazowszu") +
  theme_bw()
dev.off()

pdf("wyniki_mazowsze_2010_lokale_podzial.pdf")
ggplot(hist.data, aes(x=wynik)) + 
  geom_histogram(binwidth=.5, colour="black", fill="white") + 
  facet_grid(partia ~ .) +
  scale_x_continuous(limits=c(0, 100)) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2010 na Mazowszu") +
  theme_bw()
dev.off()