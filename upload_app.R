# Anthony R. Kesler II
# 2018-04-17 Initial Application
# Tab Delim - Upload Application and Write to Database

#Import Dependencies
library(shiny)
library(RMySQL)

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
      checkboxInput("header", "Header: Check if first row is header (default: unchecked)", FALSE)

    ),
    # Main Panel for Instructions, Review, and Upload
    mainPanel(
       tableOutput("display")
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
    output$display <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    data_set <- read.delim(file = inFile$datapath, header = input$header, nrows=2)
    data_set
    })
  # Function Used to Upload Data
    uploadData_Custom <- function(dataToUpload){
      passwordFile <- '/Secure/Path/to/file/faux_creds.R' #FilePath to Password File
      source(passwordFile) #See faux_creds.R - Keeping out of Global Environment
      mydb <- livedb_connection() # Imported function from db_connection
      #Append to web_uploads table in MySQL Server
      dbWriteTable(mydb, name='web_uploads', value=dataToUpload, append=TRUE, row.names=FALSE)
      # For security and projection against SQL Injections, dbWriteTable uses: 
      # dbQuoteIdentifier(), for more info: https://cran.r-project.org/web/packages/DBI/DBI.pdf
      dbDisconnect(mydb)
    }
  # Insert data into database
}

# Run the application 
shinyApp(ui = ui, server = server)

