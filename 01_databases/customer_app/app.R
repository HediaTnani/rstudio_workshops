library(shiny)
library(DBI)
library(dbplyr)
library(dplyr)
library(ggplot2)

options(bitmapType='cairo')

# Set Environment vars
# Sys.setenv(uid = "rstudio_prod", pwd = "prod_user")


con <- dbConnect(odbc::odbc(), 
                 driver = "PostgreSQL",
                 server = "localhost",
                 uid = Sys.getenv("uid"),
                 pwd = Sys.getenv("pwd"),
                 port = 5432,
                 database = "postgres")


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("customer", "Customer", "", "")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            verbatimTextOutput("text"),
            plotOutput("plot"),
            DT::DTOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    ord <- tbl(con, in_schema("retail", "orders"))
    cust <- tbl(con, in_schema("retail", "customer"))
    date <- tbl(con, in_schema("retail", "date"))
    
    custs <- cust %>% count(customer_name) %>% pull(customer_name)
    updateSelectInput(session, "customer", choices = custs, selected = custs[1])
    
    dat <- reactive({
        req(input$customer)
        
        ord %>%
            inner_join(cust) %>%
            inner_join(date) %>%
            filter(customer_name == !!input$customer) %>%
            select(date, customer_name, customer_phone, order_id) %>%
            arrange(date) %>%
            collect() %>%
            mutate(date = as.Date(date))
    })
    
    order_count <- reactive({
        dat() %>%
            count(date)
    })
    
    output$text <- renderText({
        glue::glue("{dat()$customer_name[1]}: {dat()$customer_phone[1]}")
    })
    
    output$table <- DT::renderDT({
        order_count() %>%
            arrange(desc(date)) %>%
            rename(`N Orders` = n)
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
