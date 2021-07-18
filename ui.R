# Entregable
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)

source('pre_load.R')

################################################################################
#####                            Variables                                 #####      
################################################################################

###### Generales
states <- c("Todo", "Aguascalientes", "Baja California", "Baja California Sur",
            "Campeche", "Coahuila", "Colima", "Chiapas", "Chihuahua", "Ciudad de México",
            "Durango", "Guanajuato", "Guerrero", "Hidalgo", "Jalisco", "México", "Michoacán", 
            "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", 
            "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", 
            "Veracruz", "Yucatán", "Zacatecas", "Nacional") 

indices <- c("Todo", "HSGD", "WGD")

areas <- c("Todo", "BCA", "BCS", "CEN", "NES", "NOR", "NTE", "OCC", "ORI", "PEN", "Nacional") 


varsFlujos <- c("Todos", setdiff(names(dataFlujos), c("Fecha")), "Total")
varsFlujosMes <- c("Todos", dataFlujosM$name)


################################################################################
#####                          Encabezado                                  #####      
################################################################################

header <- dashboardHeaderPlus(
  title = "CFE International",
  enable_rightsidebar = TRUE,
  rightSidebarIcon = "gears"
)


######### Barra Izquierda ######### 

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "tabs",
    menuItem("Inicio", tabName = "inicio"),
    menuItem("Precios", tabName = "precios"),
    menuItem("Flujos", tabName = "flujos"),
    menuItem("Demanda de Energía", tabName = "demanda")
  )
)


######### Tabs #########                                  

###### Inicio
tabInicio <- tabItem("inicio",
  box(title = "Introducción", 
      width = NULL, 
      solidHeader = TRUE,
      status = "primary", 
      p("El gas natural es el hidrocarburo de combustión más limpia. Es abundante en el planeta y versátil, por lo que ha servido para satisfacer la creciente demanda de energía a nivel mundial y puede asociarse con fuentes de energía renovable. Proporciona calor para actividades domésticas y alimenta centrales eléctricas, también alimenta muchos procesos industriales que producen variedad de insumos y bienes de consumo."),
      p("De acuerdo con", a("SHELL", href = "https://www.shell.com/energy-and-innovation/natural-gas/natural-gas-and-its-advantages.html"),", puesto que la demanda de gas va en aumento, se espera que, para 2030, su nivel haya incrementado en un 40 % desde su nivel en 2014."),
      ),
  box(title = "Objetivo", 
      width = NULL, 
      solidHeader = TRUE,
      status = "warning",
      p("En los siguientes apartados se presenta información relevante para comprender mejor el rumbo del mercado del gas natural, se presenta información sobre precios, flujos en puntos de internación, demanda de energía así como producción nacional y temperatura de Estados Unidos.")
      ),
  plotlyOutput("plotmap")
  )

#### Precios
tabPrecios <- tabItem("precios",
                      tabBox(
                        id = "tabPrecios",
                        width = NULL,
                        tabPanel(
                          "Niveles",
                          fluidRow(
                            column(
                              width = 3,
                              boxPad(
                                title = "Variables",
                                status = "primary",
                                collapsible = TRUE,
                                width = NULL,
                                color = "gray",
                                selectInput('indicen', 'índice', indices, selected = "Todo")
                              ),
                              box(title = "Descripción", 
                                  width = NULL, 
                                  solidHeader = TRUE,
                                  status = "warning",
                                  p("En la gráfica se observan los índices de precios Houston Ship Chanel Gas Daily (HSGD) y Waha Gas Daily (WGD), ambos en (USD/MMB)"),
                                  p("A pesar de que el consumo mundial de gas natural se ha incrementado a través de los años, los índices de precios se han mantenido, con excepción de los días de medio mes de febrero, debido al desabasto generado por las tormentas invernales en el sur de Estados Unidos. (", a("BP Statistical Review of World Energy", href = "https://www.bp.com/content/dam/bp/business-sites/en/global/corporate/pdfs/energy-economics/statistical-review/bp-stats-review-2021-full-report.pdf"), ") (", a("NY Times", href = "https://www.nytimes.com/live/2021/02/15/us/winter-storm-weather-live"), ")")
                              )
                            ),
                            box(
                              title = "",
                              status = "primary", 
                              collapsible = TRUE,
                              width = 9,
                              plotlyOutput("plotNivPrecios")
                            )
                          )
                        ),
                        tabPanel(
                          "Cambios relativos",
                          fluidRow(
                            column(
                              width = 3,
                              boxPad(
                                title = "Cambios relativos",
                                status = "primary",
                                collapsible = TRUE,
                                width = NULL,
                                color = "gray",
                                selectInput('indicev', 'índice', indices, selected = "Todo")
                              ),
                              box(title = "Descripción", 
                                  width = NULL, 
                                  solidHeader = TRUE,
                                  status = "warning", 
                                  p("En la gráfica se observan los cambios relativos al día anterior de los índices de precios Houston Ship Chanel Gas Daily (HSGD) y Waha Gas Daily (WGD)")
                              )
                            ),
                            box(
                              title = "Cambio relativo en porcentaje",
                              status = "primary", 
                              collapsible = TRUE,
                              width = 9,
                              plotlyOutput("plotVarPrecios")
                            )
                          )
                        )
                      )
)




###### Flujos
tabFlujos <- tabItem("flujos",
                       tabBox(
                         id = "tabFlujos",
                         width = NULL,
                         tabPanel(
                           "Flujo de Gas Natural en 17 puntos de internación", 
                           fluidRow(
                             column(
                               width = 3,
                               boxPad(
                                 color = "gray",
                                 selectInput('varConsumo2', 'Variable', varsFlujos, selected = "Todos")
                               ),
                               box(title = "Descripción", 
                                   width = NULL, 
                                   solidHeader = TRUE,
                                   status = "warning",
                                   p("En la gráfica se observan flujos por punto de internación en MMBtu/día. En México, más del 95 % del gas natural importado proviene de Estados Unidos. (", a("BP Statistical Review of World Energy", href = "https://www.bp.com/en/global/corporate/energy-economics/statistical-review-of-world-energy.html"), ")")
                               )
                             ),
                             box(
                               title = "Flujo diario",
                               status = "primary", 
                               collapsible = TRUE,
                               width = 9, 
                               plotlyOutput("plotFlujos1")

                             )
                           )
                         ),
                         tabPanel(
                           "Flujo mensual",
                           fluidRow(
                             column(
                               width = 3,
                               boxPad(
                                 title = "Variables",
                                 status = "primary",
                                 collapsible = TRUE,
                                 width = NULL,
                                 color = "gray",
                                 selectInput('varConsumo3', 'Variable', varsFlujos, selected = "Todos")
                               ),
                               box(title = "Descripción", 
                                   width = NULL, 
                                   solidHeader = TRUE,
                                   status = "warning", 
                                   p("Agregado mesual de flujo por  punto de internación, destacan los puntos 9, 12 y 13 durante 2019, mientrás que en 2020 lo hacen los puntos 4, 5, 16 y 7.")
                               )
                             ),
                             box(
                               title = "Flujo agregado mensual",
                               status = "primary",
                               collapsible = TRUE,
                               width = 9,
                               plotlyOutput("plotFlujos2") 
                             )
                           )
                         )
                       )
)


###### Demanda
tabDemanda <- tabItem("demanda", 
                       tabBox(
                         id = "tabDemanda",
                         width = NULL,
                         tabPanel(
                           "Demanda diaria", 
                           fluidRow(
                             column(
                               width = 3,
                               boxPad(
                                 color = "gray",
                                 selectInput('stateDem1', 'Areas', areas, selected = "Todo"),
                                 sliderTextInput("mesDem", "Mes",
                                                 choices = months[1:12],
                                                 selected = months[1])
                               ),
                               box(title = "Descripción", 
                                   width = NULL, 
                                   solidHeader = TRUE,
                                   status = "warning", 
                                   p("En la gráfica se presenta la serie de tiempo de demanda de energía en México para cada región del Sistema Eléctrico Nacional en miles de MGh ", a("(CENACE)", href = "https://www.cenace.gob.mx/Paginas/SIM/Reportes/PronosticosDemanda.aspx#:~:text=Para%20cada%20hora%20del%20D%C3%ADa,env%C3%ADan%20los%20Participantes%20del%20Mercado.")),
                                   p("En el mapa se presenta la demanda agregada por mes en miles de MGh para la región a la que pertenece cada estado en su mayoría", a("(SENER)", hfer = "https://www.gob.mx/cms/uploads/attachment/file/54139/PRODESEN_FINAL_INTEGRADO_04_agosto_Indice_OK.pdf")),
                                   p("En México, el 52 % de la energía que se consume se genera a partir de Gas Naural", a("(EIA, 2020)", href = "https://www.eia.gov/international/analysis/country/MEX"))
                               )
                             ),
                             box(
                               title = "Gráficos",
                               status = "primary", 
                               collapsible = TRUE,
                               width = 9, 
                               plotlyOutput("plotDem1"),
                               plotlyOutput("mapDem")
                             )
                           )
                         ),
                         tabPanel(
                           "Demanda diaria desestacionalizada", 
                           fluidRow(
                             column(
                               width = 3,
                               boxPad(
                                 color = "gray",
                                 selectInput('demandaDes', 'Areas', areas, selected = "Todo")
                               ),
                               box(title = "Descripción", 
                                   width = NULL, 
                                   solidHeader = TRUE,
                                   status = "warning", 
                                   p("Eliminar la estacionalidad en una serie de tiempo permite hacer comparaciones entre un periodo y otro, aislando la variación introducida por la presencia de estacionalidad. (", a("CEPAL", href = "https://www.cepal.org/sites/default/files/courses/files/01_4_ajuste_estacional.pdf"), ")")
                               )
                             ),
                             box(
                               title = "Gráficos",
                               status = "primary", 
                               collapsible = TRUE,
                               width = 9, 
                               plotlyOutput("plotDemandaDes")
                             )
                           )
                         )
                         
                         
                         
                         
                         
                         
                       )
)

######### Cuerpo #########      
body <- dashboardBody(
  tabItems(
    tabInicio,
    tabPrecios,
    tabFlujos,
    tabDemanda
  )
)


######### Barra Derecha #########                               
rightsidebar <- rightSidebar()  

######### Servidor #########   

shinyUI(dashboardPagePlus(header, sidebar, body, rightsidebar))
  
