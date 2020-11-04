library(shiny)

bike_map_UI <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(
      ns("map")
    )
  )
}

bike_map_server <- function(id, plot_dat, stations) {
  moduleServer(
    id, 
    function(input, output, session) {
      output$map <- renderLeaflet(
        bikeRpkg::make_bike_map(plot_dat, stations)
      )
    }
  )
}
