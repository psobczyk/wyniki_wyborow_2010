#' 
#' Piotr Sobczyk
#' Analiza frekwencja, nieważnych głosów dla wyborów 2010
#' 

dane2010 <- read.csv("mazowsze2010.csv")
duze.partie <- c("Komitet Wyborczy Polskie Stronnictwo Ludowe",
                 "Komitet Wyborczy Prawo i Sprawiedliwość",
                 "Komitet Wyborczy Platforma Obywatelska RP",
                 "KOMITET WYBORCZY SOJUSZ LEWICY DEMOKRATYCZNEJ")

#do rysowania wykresów, nie musimy tworzyć nowych ramek danych
#po prostu przekazujemy zmienioną ramkę danych jako wejście dla ggplota
dane2010 %>%
  filter(partia %in% toupper(duze.partie),
         wyborcy > 500) %>%
  mutate(niewazne = 100*(1-wazne/oddane)) %>%
  select(typ, niewazne, partia, wynik) %>%
  ggplot(aes(y=wynik, x=niewazne)) + 
  geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
  facet_grid(typ ~ partia)+
  geom_smooth(formula=y~ ns(x,3), method = "gam") +
  xlab("% głosów nieważnych") +
  ylab("Poparcie w %") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme.basic

dane2010 %>%
  filter(partia %in% toupper(duze.partie),
         wyborcy > 500) %>%
  mutate(frekwencja = 100*oddane/wyborcy) %>%
  select(typ, frekwencja, partia, wynik) %>%
  ggplot(aes(y=wynik, x=frekwencja)) + 
  geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
  facet_grid(typ ~ partia)+
  geom_smooth(formula=y~ ns(x,3), method = "gam") +
  xlab("Frekwencja w %") +
  ylab("Poparcie w %") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme.basic

dane2010 %>%
  filter(wyborcy > 500) %>%
  mutate(frekwencja = 100*oddane/wyborcy) %>%
  group_by(partia) %>% 
  summarize(poparcie = sum(wynik*frekwencja*wyborcy)/sum(frekwencja*wyborcy/10000),
            mediana = median(wynik)) %>%
  arrange(desc(poparcie)) 
