#' 
#' Piotr Sobczyk 
#' 

source("wczytywanie_danych.R")

#Ze względu na klarowność wykresu 
#bierzemy pod uwagę tylko 4 największe partie
#oraz komisje obwodowe o więcej niż 100 wyborcach
duze.partie <- unique(dane$partia)[c(1,3,4,6)]
dane2 <- dane %>%
  filter(wyborcy > 500,
         partia %in% duze.partie)

png("wyniki_calosc_2014_lokale_podzial.png", width = 800, height = 1000)
ggplot(dane2, aes(x=wynik)) + 
  geom_histogram(binwidth=.5, colour="black", fill="gray") + 
  facet_grid(partia ~ .) +
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  scale_x_continuous(limits=c(0, 80)) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme_bw()
dev.off()

ggplot(dane2, aes(x=wynik, fill=partia)) + 
  geom_density(alpha=.3, kernel="gau") +
  scale_x_continuous(limits=c(0, 100)) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme(legend.position="top") + 
  scale_fill_hue()

source("multiplot.R")
for(j in 1:4){  
  komitet <- duze.partie[j]
  dane.partia <- dane2 %>% 
    filter(partia == komitet,
           wojewodztwo %in% wybrane.wojewodztwa) %>%
    select(wojewodztwo, wynik)
  p <- list()
  for(i in 1L:16){
    w <- wybrane.wojewodztwa[i]
    d.temp <- dane.partia %>%
      filter(wojewodztwo == w)
    p[[i]] <- ggplot(d.temp, aes(x=wynik, fill=wojewodztwo)) + 
      geom_histogram(binwidth=.5, colour="black", fill="white") + 
      xlab("Poparcie w %") +
      ylab("Liczba lokali wyborczych") +
      ggtitle(paste0("Województwo ", w)) +
      guides(fill=FALSE)
  }
  
  #paste0("p[[", 1:16, "]]", collapse=", ")
  filename <- paste0("wyniki_calosc_", gsub(" ", "_", komitet), "_wojewodztwa.png")
  png(filename, width = 1400, height = 800)
  multiplot(p[[1]], p[[2]], p[[3]], p[[4]], p[[5]], p[[6]], p[[7]], p[[8]], p[[9]], p[[10]], p[[11]], p[[12]], p[[13]], p[[14]], p[[15]], p[[16]], cols = 4, 
            title=paste(komitet,"- wynik w wyborach samorządowych 2014 w podziale na województwa"))
  dev.off()
}

