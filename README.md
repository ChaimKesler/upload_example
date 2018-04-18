# Shiny App Upload Tool Example
ShinyApp to upload data to an existing MySQL database

This application is an example of a shiny uploader tool, where data is uploaded from a tab delimited file and appended to a table in a MySQL database.

## Dependencies
The code was written and tested using: 
R version 3.4.3 (2017-11-30) -- "Kite-Eating Tree"
Platform: x86_64-apple-darwin15.6.0 (64-bit)

The following required libraries were updated and used on 2018-04-17:
* shiny
* RMySQL
* anytime

In addition, the code presumes that an existing MySQL database is set-up, and that a table is set-up to recieve data. An example file with how to source the credentials is provided in the faux_creds.R script, also shown below.

```{r}
# Sample Mapping to Load DB Credentials
livedb_connection <- function() {
    mydb = dbConnect(MySQL(),
        user = 'user',
        password = 'password',
        db = 'database',
        host = '###.#.#.#',
        port = 3306)
}
```
For reference, the name of the target database is defined in the following RmySQL function:

```{r}
dbWriteTable(mydb, name='web_uploads', value=dataToUpload, append=TRUE, row.names=FALSE)
```

## Future Development Items
The following is a list of future development items:
* 'Upload ID' and/or timestamp for Reference (both returned in UI after upload and Inserted in Database)
* Log files for output, for tracking and trouble shooting
* Authentication: publishing requires local Shiny server for authentication (or SSO via cloud service)
* Expand error handling to catch issues with data and SQL Upload and data validation (will be rejected presently by RMySQL functions if type mismatch is detected)
* Type checking on the rows (columns headers and sql errors handled by dbWriteTable)
* Update to include better User Experience (e.g. auto-refresh of page / reset) after upload

## Running Script
The following are the recommended steps for running the application, using RStudio:
* Create a new packrat project with git tracking in a new directory
* Place the scripts in the associated directly
* Install dependencies / libraries listed above
* Validate any hard coded file paths (e.g. sample table and credentials)
* Check connection to MySQL Database by loading creds
* Run Shiny App and Validate
* Publish to a Shiny Server
* For more info, please see: https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/
