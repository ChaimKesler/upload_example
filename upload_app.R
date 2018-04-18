# Anthony R. Kesler II
# 2018-04-17 Initial Application
# Tab Delim - Upload Application and Write to Database

#Import Dependencies
library(shiny)
library(RMySQL)
library(anytime)

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
       h2("Upload Instructions"),
       ("Instruction Text"),
       hr(),
       textOutput("upload_status"),
       tableOutput("display"),
        actionButton("uploadData", "Click to Upload Data"),
       textOutput("rows_to_upload")
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
          column_check <- ncol(data_set)
      if (input$header == 'FALSE')
        column_check <- ncol(data_set)
        if (column_check == 11)
        names(data_set) <- c("customer_id","first_name","last_name","street_address"
                            ,"state_code","zip_five","status","product_id","product_name"
                            ,"purchase_amount","purchase_datetime" 
                            )
    data_set
    #Want to be able to review if incorrect - allowing preview
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
      output$rows_to_upload <- renderText({
      inFile <- input$file1
      if (is.null(inFile)) return()
      if(input$uploadData==0)
        return("Upload Not Started.")
      data_set <-  read.delim(file = inFile$datapath, header = input$header)
      column_check <- ncol(data_set)
      if (column_check != 11)
        return(paste("Issue with file: ",column_check," detected and only 11 accepted!",sep=""))
      if (input$header == 'FALSE')
      names(data_set) <- c("customer_id","first_name","last_name","street_address"
                          ,"state_code","zip_five","status","product_id","product_name"
                          ,"purchase_amount","purchase_datetime" 
                          )
      data_set$purchase_datetime <- iso8601(anytime(data_set$purchase_datetime))
      row_count <- nrow(data_set)
      upload_response <- 'EMPTY' #Setting for generic tests
      # upload_response <- uploadData_Custom(data_set)
      rm(data_set)
      if(upload_response=='TRUE')  
        return(paste("Uploaded rows: ",as.character(row_count),sep=""))
      if(upload_response=='EMPTY')
        return("uploadData_Custom Function Commented Out") #For the purpose of publishing publicly
      return(paste("Warning: Upload Failed: ",upload_response,sep=""))
    })
  }


# Run the application 
shinyApp(ui = ui, server = server)

