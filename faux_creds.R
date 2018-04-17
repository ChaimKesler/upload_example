# Sample Mapping to Load DB Credentials
livedb_connection <- function() {
    mydb = dbConnect(MySQL(),
        user = 'user',
        password = 'password',
        db = 'database',
        host = '###.#.#.#',
        port = 3306)
}
