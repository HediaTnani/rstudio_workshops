#' Make Plot Data from Station and Status
#'
#' @param station station df
#' @param status status df
#'
#' @return combined plot data
#' @export
#'
#' @examples
#' make_plot_dat(pins::pin_get("break_up_station_dat"), pins::pin_get("break_up_bike_dat"))
make_plot_dat <- function(station, status) {
  dplyr::inner_join(station, status) %>%
    dplyr::mutate(
      plot_val = glue::glue(
        paste0(
          "<b>{name}</b><br>",
          "Bikes: {num_bikes_available}<br>",
          "Empty Docks: {num_docks_available}"
        ))
    )
}

#' Make Leaflet map of bike data
#'
#' @param dat output from make_plot_dat
#'
#' @return leaflet object
#' @export
#'
#' @examples
#' dat <- make_plot_dat(pins::pin_get("break_up_station_dat"), pins::pin_get("break_up_bike_dat"))
#' make_bike_map(dat)
make_bike_map <- function(dat, stations) {
  dat %>%
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
      popup = ~paste0(plot_val)
    )
}

#' Get Bike Data
#'
#' @param url URL of API
#' @param which which data set to get
#'
#' @return data.frame
#' @export
#'
#' @examples
#' get_dat("http://127.0.0.1:5249", "station")
get_dat <- function(url, which) {
  httr::GET(
    file.path(url, "get_dat"), 
    query = list(which = which)
  ) %>%
    httr::content() %>%
    purrr::map_dfr(tibble::as_tibble)
}
