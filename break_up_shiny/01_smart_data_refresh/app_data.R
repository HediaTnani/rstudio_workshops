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
  plot_dat <- inner_join(stations, dat) %>%
    mutate(name_val = glue::glue(
      paste0(
        "<b>{name}</b><br>", 
        "Bikes: {num_bikes_available}<br>", 
        "Empty Docks: {num_docks_available}"
      ))
    )
  
  #----- Create Map -----
  output$map <- renderLeaflet({
    plot_dat %>%
      leaflet() %>%
      addProviderTiles(
        providers$CartoDB.Positron
      ) %>%
      setView(
        lng = median(stations$lon), 
        lat = median(stations$lat), 
        zoom = 14
      ) %>%
      addAwesomeMarkers(
        lng = ~lon,
        lat = ~lat,
        icon = awesomeIcons(
          "bicycle",
          library = "fa",
          iconColor = "white",
          markerColor = "red"
        ),
        popup = ~paste0(name_val)
      )
  })
}

# Run the application
shinyApp(ui = ui, server = server)