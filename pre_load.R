# Entregable
# Cargamos paquetes
library(tidyverse)
library(readxl)
library(sf)
library(plotly)
library(knitr)
library(lubridate)
library(kableExtra)
library(dplyr)


# Funciones auxiliares
vline <- function(x = 0, color = "grey") {
  list(
    type = "line", 
    y0 = 0, 
    y1 = 1, 
    yref = "paper",
    x0 = x, 
    x1 = x, 
    line = list(color = color, width = 1)
  )
}

months <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", 
            "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")




mexico <- st_read("Datos/geoMexico.shp")

# Cargamos bases
## Precios
dataNivPrecios <- read_csv("Datos/NivPrecios.csv")
dataVarPrecios <- read_csv("Datos/VarPrecios.csv")

##Flujos
dataFlujos <- read_csv("Datos/Flujos.csv")
dataFlujosM <- read_csv("Datos/FlujosMesT.csv")
dataFlujosMes <- read_csv("Datos/FlujosMes.csv")


##Demanda de energía en México
dataDemanda <- read_csv("Datos/DemandaAreas.csv")
dataDemandaDes <- read_csv("Datos/DemandaAreasDes.csv")


geoDemanda <- st_read("Datos/geoDemanda.shp")



