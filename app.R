library(shiny)
library(plotly)
library(shiny)
library(reshape2)
library(dplyr) # I think this is for filter()

# setwd("C:\\GlobalNitrogen_app_v3\\n_app\\")
# getwd()

df_min <- read.csv('GlobalNStudyFinal_Amin.csv')
df_max <- read.csv('GlobalNStudyFinal_Amax.csv')
df_med <- read.csv('GlobalNStudyFinal_Amed.csv')
DataType_lst <- unique(df_min$data_type)
Fertilizer_lst <- c("Benchmark_max_Fertilizer","Benchmark_median_Fertilizer","Benchmark_min_Fertilizer")
Manure_lst <- c("Benchmark_max_Manure","Benchmark_median_Manure","Benchmark_min_Manure")
Fixation_lst <- c("Benchmark_max_Fixation","Benchmark_median_Fixation","Benchmark_min_Fixation")
Deposition_lst <- c("Benchmark_max_Deposition","Benchmark_median_Deposition","Benchmark_min_Deposition")
Harvest_lst <- c("Benchmark_max_Harvest","Benchmark_median_Harvest","Benchmark_min_Harvest")

l <- list(color = toRGB("grey"), width = 0.5)
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator'))

###########################################
ui <- fluidPage(
  titlePanel("Welcome to the Global Nitrogen Database (Draft Application)!"),
  # Copy the line below to make a select box 
  selectInput("select", label = h6("Which Nitrogen Input/Output Would You Like to View?"), 
              choices = c('Fertilizer', 'Manure', 'Fixation', 'Deposition', 'Harvest'), 
              selected = 1),
  selectInput("select2", label = h6("Which Benchmark Would You like to View?"), 
              choices = c('min', 'max', 'median'), 
              selected = 1),
  selectInput("select3", label = h6("Normalize By Area: Min, Max, or Median Area (km^2)?"), 
              choices = c('min', 'max', 'median'), 
              selected = 1),
  fluidRow(plotlyOutput("map"))
)
###########################################
server <- function(input, output) {
  output$"map" <- 
    renderPlotly({
      if (input$'select3'== 'min'){ # choose which normalized df you want to view
        df <- df_min
      }
      else if (input$'select3'== 'max'){
        df <- df_max
      }
      else if (input$'select3'== 'median'){
        df <- df_med
      }
      # create a string of user-chosen input/output (e.g., 'Benchmark_max_Fertilizer') based on user input
      data_selection <- paste0('Benchmark_',input$'select2' ,'_',input$'select')
      df_select <- filter(df, df$data_type == data_selection)
      
      if (data_selection %in% Fertilizer_lst){
        graph_color <- 'Reds'
      }
      else if (data_selection %in% Manure_lst){
        graph_color <- 'Greens'
      }
      else if (data_selection %in% Fixation_lst){
        graph_color <- 'Purples'
      }
      else if (data_selection %in% Deposition_lst){
        graph_color <- 'Oranges'
      }
      else if (data_selection %in% Harvest_lst){
        graph_color <- 'Greys'
      }
      plot_geo(df_select, frame = ~Year) %>% 
        add_trace(z = ~value, color = ~value, colors = graph_color, 
                  text = ~Country, locations = ~ISO3, marker = list(line = l)) %>% 
        colorbar(title = 'k ton N/ km^2') %>% # include limits = c(min, max)  in colorbar() if you want static legend (might have to be input/output specific)
        layout(title = 'Global And National Nitrogen Budgets<br>Source:<a href="https://www.nature.com/articles/s43016-021-00318-5">Zhang et al 2021</a>', 
               geo = g) %>% 
        config(displayModeBar = FALSE)
      })
  }
###########################################
shinyApp(ui = ui, server = server)
