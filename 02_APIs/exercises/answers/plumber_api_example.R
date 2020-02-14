#* @apiTitle My First Plumber API

#* My API endpoint description: add 2 numbers together!
#* @param x Value 1
#* @param y Value 2
#* @get /echo
function(x, y) {
  as.numeric(x) + as.numeric(y)
}