# Call the shiny library
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)

## Load resource list
## Note: If you encounter issues with characters, try resaving the 
## CSV as a UTF-8 CSV. Excel... does not like interpreting as UTF-8
data <- read_csv("data/thrive_resources.csv", comment = "#")

## Change to factor-based data for "tagged" search
data$Category <-as.factor(data$Category)
data$Type <-as.factor(data$Type)

#----------------------------------------------#
#                User Interface                #
#----------------------------------------------#

ui <- dashboardPage(skin="black",
## Header
  dashboardHeader(
    title = "Crisis Resources",
    titleWidth = 325),

## Sidebar
  dashboardSidebar(
    img(src = "Thrive_Logo.png", height = 200, width = 325, 
        alt="THRIVE Lifeline logo"),
    ## Adjust to match titleWidth
    width = 325,
    ## Note
    h5("If there are any issues with this list, please contact:"),
    a("info@thrivelifeline.org", href = "mailto:info@thrivelifeline.org")
  ),

## Body
  dashboardBody(

    ## Define language for screenreader/508 compliance
    tags$html(lang="en"),
    
    ## Change link color
    tags$style(HTML('a:link {color:#0237D4}')),
    
    ## Make title bold
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    
    ## Display Data Table
    DTOutput(outputId = "table"),
    
    ## Add date updated/org info
    h5("Last Updated:", format(Sys.Date(), format="%d %B %Y"), align = "center"),
    h5("THRIVE Inc.", align = "center")
  )
)

#----------------------------------------------#
#                    Server                    #
#----------------------------------------------#

## Define server logic to summarize and view selected dataset
server <- function(input, output) {
  
## Show table, render hyperlinks
  output$table <-DT::renderDataTable(DT::datatable(
    ## Name of dataset
    data,
    ## Allow individual column search
    filter = 'top',
    ## Remove index column
    rownames = FALSE,
    ## Escaping HTML entities
    escape = FALSE
    ## Add some buttons
    #extensions = 'Buttons', options = list(
     # dom = 'Bfrtip',
      #buttons = ('colvis')
      #buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    #)
    )
  )
}

## Create Shiny app
shinyApp(ui = ui, server = server)