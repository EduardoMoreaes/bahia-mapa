#install.packages ("rgdal")
#install.packages ("ggplot2")
#install.packages("rgeos")
#install.packages("gpclib")
#install.packages("maptools")
#install.packages ("readr")

library(gpclib)
library(maptools)
library(rgeos)
library (ggplot2)
library (rgdal)
library (readr)

bh <- readOGR(file.choose())
head(bh)

bh$CD_GEOCODM  <- substr(bh$CD_GEOCODM,1,6) 
nascimentos <- read.csv2(file.choose(), header = T, sep = ",")     #o header é f, porque o csv não twm cabeçalho


nascimentos$CD_GEOCODM <- substr(nascimentos$municipio,1,6)
##########################################################


nascimentos <- nascimentos[order(nascimentos$CD_GEOCODM),] 
malhaBH <- bh@data[order(bh@data$CD_GEOCODM),]
nascimentos <- nascimentos[-1,]
head(malhaBH)
head(nascimentos)


dim (nascimentos)
dim (malhaBH)
bh2 <- merge (malhaBH,nascimentos)

head(bh)

###################################


bh.bhf <- fortify(bh, region = "CD_GEOCODM")
head(bh.bhf)

bh.bhf <- merge(bh.bhf, bh@data, by.x = "id", by.y = "CD_GEOCODM")
bh.bhf <- merge(bh.bhf, bh2, by.x = "id", by.y = "CD_GEOCODM")
head(bh.bhf)
bh.bhf <- bh.bhf[,-c(8,10,11, 12)]
############até aqui ok

bh.bhf$nascimentosCat <- cut(bh.bhf$nascimentos, breaks = c(0,50,100,200,300,400,1000),
                        labels = c('0-50',
                                   '50-100',
                                   '200-300',
                                   '300-400',
                                   '400-1000',
                                   '+1000'),
                        include.lowest = T)


install.packages("RColorBrewer",dependencies = T)
library(RColorBrewer)

mapa_ggplot <-ggplot(bh.bhf, aes(long, lat, group=group, fill= nascimentosCat))+
  geom_polygon(colour='black')+ coord_equal() + ggtitle("Nascimentos na Bahia em 2020") +
  labs(x = "Longitude", y = "Latitude", fill="nascimentos") + 
  scale_fill_manual(values=brewer.pal(9, 'PuRd')[4:9])+
  theme(plot.title=element_text(hjust = 0.5) );

  mapa_ggplot  
    
