library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(DT)
library(ggplot2)

#setwd("C:/Users/kalsr/Documents")
# Read the data
data <- readxl::read_excel("C:/Users/kalsr/Documents/drugScreenPivotData/data/screening_data.xlsx", sheet = "data")

# Define the UI
ui <- dashboardPage(
    dashboardHeader(title = "Data Display"),
    dashboardSidebar(
        selectInput("inputcol", "Select a column:", choices = setdiff(colnames(data), "read_out"))
    ),
    dashboardBody(
        DT::dataTableOutput("table"),
        plotOutput("boxplot")
    )
)

# Define the server
server <- function(input, output) {
    output$table <- DT::renderDataTable({
        data %>%
            pivot_wider(id_cols = NULL, names_from = input$inputcol, values_from = "read_out") %>%
            datatable()
    })

    output$boxplot <- renderPlot({
        ggplot(data, aes_string(x = input$inputcol, y = "read_out")) +
            geom_boxplot()
    })
}

# Run the app
shinyApp(ui = ui, server = server)
