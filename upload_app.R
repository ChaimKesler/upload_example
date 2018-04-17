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
    ),
    # Main Panel for Instructions, Review, and Upload
    mainPanel(
    )
  )
)

# 
server <- function(input, output) {
  # Function to Check if File Has Been Loaded
  # Upload first five rows of data for preview
  # Function Used to Upload Data
  # Insert data into database
}

# Run the application 
shinyApp(ui = ui, server = server)

