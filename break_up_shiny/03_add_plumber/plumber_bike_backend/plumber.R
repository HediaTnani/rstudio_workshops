library(plumber)
library(magrittr)
library(dplyr)

#* @apiTitle Bike Data Access API

#* Get the data
#* @param which one of "station", "bike"
#* @get /get_dat
function(which = c("station", "bike")) {
  match.arg(which)
  
  pins::pin_get(
    glue::glue(
      "break_up_{which}_dat"
    )
  )
}