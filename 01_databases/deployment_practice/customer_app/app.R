library(shiny)
library(DBI)
library(dbplyr)
library(dplyr)
library(ggplot2)

options(bitmapType='cairo')
if (interactive()) source("~/class-repo/.Rprofile")

# Let's use Environmental Variables to Connect
con <- dbConnect(
    odbc::odbc(),
    Driver   = "PostgreSQL",
    Server   = "localhost", 
    Port     = 5432,
    Database = "postgres",
    
    ######### FILL IN ###########
    # Need to get username and password from environment vars
    # Maybe check ~/class-repo/.Rprofile?
    UID      = ???, # Username
    PWD      = ???  # Password
)



# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Purchasing Data by Customer"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("customer", "Customer", "", "")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    ########### Fill In ############
    # Fill in table names, perhaps connect to the database to get the names?
    orders <- tbl(con, in_schema("retail", ???))
    cust <- tbl(con, in_schema("retail", ???))
    date <- tbl(con, in_schema("retail", ???))
    
    custs <- cust %>% count(customer_name) %>% pull(customer_name)
    updateSelectInput(session, "customer", choices = custs, selected = custs[1])
    
    dat <- reactive({
        req(input$customer)
        
        ########## Fill In  ############
        # I need to collect() this data so I can plot it. 
        # I want to collect() as late as possible, but need to make sure everything's properly formatted
        # You can try running this chunk (63-70) to see if you got it, then try running the app.
        orders %>%
            inner_join(cust) %>%
            inner_join(date) %>%
            ############ Fill In ##########
            # I want to use the input$customer value...but I need to get it to evaluate before I send...
            filter(customer_name == ?????) %>%
            select(date, customer_name, customer_phone, order_id) %>%
            arrange(date) %>%
            mutate(date = as.Date(date))
    })
    
    order_count <- reactive({
        dat() %>%
            count(date)
    })
    
    output$plot <- renderPlot({
        order_count() %>%
            ggplot(aes(x = date, y = n, group = 1)) +
            geom_line() +
            xlab("Date") +
            ylab("N Orders") +
            theme_linedraw() +
            stat_smooth()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
