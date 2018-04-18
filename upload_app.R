# Anthony R. Kesler II
# 2018-04-17 Initial Application
# Tab Delim - Upload Application and Write to Database

#Import Dependencies
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Uploader App"),
  
  # Side Panel - Add Upload Tool Here 
  sidebarLayout(
    sidebarPanel(
      #Input file
      fileInput("file1", "Choose CSV File",
                accept = c(
                 "text/csv",
                 "text/comma-separated-values,text/plain",
                 ".csv",
                 ".txt")
      ),
      tags$hr(),
      checkboxInput("header", "Header: Check if first row is header (default)", TRUE)
    ),
    # Main Panel for Instructions, Review, and Upload
    mainPanel(
    )
  )
)

# 
server <- function(input, output) {
  # Function to Check if File Has Been Loaded
    output$upload_status <- renderText({
      inFile <- input$file1
      if (is.null(inFile))
        return("Please select data for upload")
      "Please review your data before uploading"
    })
  # Upload first five rows of data for preview
  # Function Used to Upload Data
  # Insert data into database
}

# Run the application 
shinyApp(ui = ui, server = server)

