library(plumber)

pins::board_register("rsconnect", server = "", 
                     key = Sys.getenv("RSCONNECT_API_KEY"))
mod <- pins::pin_get("model", "rsconnect")

#* @apiTitle Model Deployment Example 

#* Provide model predictions from a plumber API
#* @param cyl n cylinders, numeric
#* @param hp horsepower, numeric
#* @param disp displacement, numeric
#* @get /pred
function(cyl, hp, disp) {
  new_dat <- data.frame(
    cyl = cyl, 
    hp = hp, 
    disp = disp
  )
  
  predict(, newdata = new_dat)
}


