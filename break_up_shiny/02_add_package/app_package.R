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

stations <- pins::pin_get("break_up_station_dat")
dat <- pins::pin_get("break_up_bike_dat")

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