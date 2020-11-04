library(shiny)
library(shinydashboard)
library(httr)
library(ggplot2)
library(dplyr)
library(leaflet)

# Create dashboard page UI
ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "Capitol Bikeshare Bikes"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    box(
      title = "Station Map",
      leafletOutput(
        "map"
      ),
      width = 12
    )
  )
)

api_url <- "http://127.0.0.1:5165"
stations <- bikeRpkg::get_dat(api_url, "station")
dat <- bikeRpkg::get_dat(api_url, "bike")

server <- function(input, output, session) {
  #----- Create Plot Data -----
  plot_dat <- bikeRpkg::make_plot_dat(stations, dat)
  
  #----- Create Map -----
  output$map <- renderLeaflet(
    bikeRpkg::make_bike_map(plot_dat, stations)
  )
}

# Run the application
shinyApp(ui = ui, server = server)