# Entregable
source('pre_load.R')


## Funciones
dailyPlot <- function(data){
  data %>% 
    gather(key = Var, value = Val, -Fecha) %>% 
    plot_ly(x = ~Fecha, y = ~Val, group = ~Var, 
            type = "scatter", color = ~Var, mode = "lines", 
            colors = viridis::plasma(ncol(data)-1)) %>% 
    layout(title = "", 
           xaxis = list(
             title = "", 
             type = "date"
             ), 
           yaxis = list(title = "")
    )
  }

monthlyPlot <- function(data){
  data %>%
    gather(key = Mes, value = Val, -nom_ent) %>%
    mutate(Mes = fct_relevel(Mes, months)) %>%
    plot_ly(x = ~Mes, y = ~Val, group = ~nom_ent,
            type = "scatter", color = ~nom_ent, mode = "lines+markers",
            colors = viridis::plasma(ncol(data)-1),
            text = ~paste("</br> Estado:", nom_ent, 
                          "</br> Valor:", Val),
            hoverinfo = "text") %>%
    layout(title = "",
           xaxis = list(title = ""),
           yaxis = list(title = "")
           )
}


mapPlot <- function(data, mes){
  plot_ly(data) %>% 
    add_sf(split = ~Estado, 
           color = ~Mes,
           span = I(1),
           text = ~paste("</br> Estado:", Estado, 
                         "</br> Valor:", Mes),
           hoverinfo = "text",
           hoveron = "fills"
    ) %>% 
    layout(showlegend = FALSE) %>% 
    colorbar(title = mes)
}

## Server                                         
shinyServer(function(input, output) {
  output$plotmap <- renderPlotly({
    mexico %>% 
      plot_ly() %>% 
      add_sf(split = ~name, 
             color = ~I("grey"),
             span = I(1)
      ) %>% 
      layout(showlegend = FALSE)
    }
  )
  
###### Precios ###### 
  
  nivprecios <- reactive({
    if(input$indicen %in% names(dataNivPrecios)){
      dataNivPrecios <- dataNivPrecios %>% 
        dplyr::select(Fecha, input$indicen)
    } else {
      dataNivPrecios <- dataNivPrecios %>% 
        dplyr::select(Fecha, HSGD, WGD)
    }
  }
  )
  
  varprecios <- reactive({
    if(input$indicev %in% names(dataVarPrecios)){
      dataVarPrecios <- dataVarPrecios %>% 
        dplyr::select(Fecha, input$indicev)
    } else {
      dataVarPrecios <- dataVarPrecios %>% 
        dplyr::select(Fecha, WGD, HSGD)
    }
  }
  )
  

  
## Gráficas
  output$plotNivPrecios <- renderPlotly({
    dailyPlot(data = nivprecios())
  }
  )
  
  
  
  output$plotVarPrecios <- renderPlotly({
    dailyPlot(data = varprecios())
  }
  )
  

#####  Flujos
  
  Flujos1 <- reactive({
    if(input$varConsumo2 %in% names(dataFlujos)){
      dataFlujos <- dataFlujos %>%
        dplyr::select(Fecha, input$varConsumo2)
    } else {
      dataFlujos <- dataFlujos %>% 
        dplyr::select(-Total)
    }
  }
  )
  
  Flujos2 <- reactive({
    if(input$varConsumo3 %in% names(dataFlujosMes)){
      dataFlujosMes <- dataFlujos %>%
        dplyr::select(Fecha, input$varConsumo3)
    } else {
      dataFlujosMes <- dataFlujosMes %>% 
        dplyr::select(-Total)
    }
  }
  )
  

  
 ## Gráfica
  
  output$plotFlujos1 <- renderPlotly({
    dailyPlot(data = Flujos1())
  }
  )
  
  output$plotFlujos2 <- renderPlotly({
    dailyPlot(data = Flujos2())
  }
  )



###### Demanda ######                               

  
  Dem1 <- reactive({
    if(input$stateDem1 %in% names(dataDemanda)){
      dataDemanda <- dataDemanda %>%
        dplyr::select(Fecha, input$stateDem1)
    } else {
      dataDemanda <- dataDemanda %>% 
        dplyr::select(-Nacional)
    }
  }
  )  
  
  DemandaDes <- reactive({
    if(input$demandaDes %in% names(dataDemandaDes)){
      dataDemandaDes <- dataDemandaDes %>%
        dplyr::select(Fecha, input$demandaDes)
    } else {
      dataDemandaDes <- dataDemandaDes %>% 
        dplyr::select(-Nacional)
    }
  }
  )
  
  
  monthDem <- reactive({
    month <- input$mesDem
  }
  )
  
  
  monthDem <- reactive({
    month <- input$mesDem
    }
  )
  

  
  mapDem <- reactive({
    geoDemanda %>% 
      dplyr::select(nom_ent, monthDem()) %>% 
      rename_all(funs(c("Estado", "Mes", "geometry")))
    }
  )
  

  output$mapDem <- renderPlotly({
    mapPlot(data = mapDem(), mes = monthDem())
  }
  )
  
  
  
  ## Gráfica
  
  output$plotDem1 <- renderPlotly({
    dailyPlot(data = Dem1())
  }
  )  
  
  output$plotDemandaDes <- renderPlotly({
    dailyPlot(data = DemandaDes())
  }
  )  

  

  }
)