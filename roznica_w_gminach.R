#'
#' Piotr Sobczyk
#' Analiza odchyłu od średniej dla gmin
#'

library(moments)
source("wczytywanie_danych.R")

duze.partie <- unique(dane$partia)[c(1,3,4,6)]
dane.diff <- dane %>%
  filter(wyborcy > 500,
         partia %in% duze.partie)

a <- aggregate(dane.diff$wynik, by=list(dane.diff$kod, dane.diff$partia), FUN = median)
b <- aggregate(dane.diff$wynik, by=list(dane.diff$kod, dane.diff$partia), FUN = length)
gmina.mediana <- NULL
for(i in 1:nrow(a)){
  gmina.mediana <- c(gmina.mediana, rep(a[i,3], b[i,3]))
}

dane.diff <- dane.diff %>%
  arrange(partia, kod)
dane.diff <- cbind(dane.diff, gmina.mediana)

dane.diff <- dane.diff %>%
  mutate(diff = wynik-gmina.mediana) %>%
  select(kod, wojewodztwo, frekwencja, niewazne, partia, wynik, gmina.mediana, diff)

ggplot(dane.diff, aes(x=diff)) + 
  geom_density(alpha=.3, kernel="gau", colour="black", fill="gray") +
  facet_grid(partia ~ .) +
  scale_x_continuous(limits=c(-20, 20)) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014")


ggplot(dane.diff, aes(x=diff)) + 
  geom_density(alpha=.3, kernel="gau", colour="black", fill="gray") +
  facet_grid(partia ~ wojewodztwo) +
  scale_x_continuous(limits=c(-20, 20)) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014")

non.zeros <- function(x){
  x[x!=0]
}
diff.kwantyle <- quantile(dane.diff$diff, seq(from = 0, to = 1, by = 0.005))
boxplot(diff~paste(partia), data=dane.diff, range = 5)
ggplot(dane.diff, aes(x=partia, y=diff, fill=partia)) + 
  geom_boxplot() + guides(fill=FALSE) +
  xlab("") + ylab("Różnica z medianą dla gminy")
skrajne.duze <- non.zeros(table(dane.diff$partia[dane.diff$diff > diff.kwantyle[["95.0%"]]]))
skrajne.male <- non.zeros(table(dane.diff$partia[dane.diff$diff < diff.kwantyle[["5.0%"]]]))

chisq.test(skrajne.duze, p = skrajne.male, rescale.p = TRUE)

aggregate(dane.diff$diff, by = list(dane.diff$partia), mean)
aggregate(dane.diff$diff, by = list(dane.diff$partia), sd)
aggregate(dane.diff$diff, by = list(dane.diff$partia), function(x) quantile(x, 0.75)-quantile(x,0.25))
aggregate(dane.diff$diff, by = list(dane.diff$partia), skewness)
aggregate(dane.diff$diff, by = list(dane.diff$partia), kurtosis)

