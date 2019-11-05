library(RCurl)
library(XML)

#http://wonder.cdc.gov/mmwr/mmwrmort.asp


uri <- "http://wonder.cdc.gov/mmwr/mmwr_reps.asp?mmwr_table=4A&mmwr_year=2010&mmwr_week=09&mmwr_location=Lynn%2C+Mass."
readHTMLTable(uri)[8]
names(readHTMLTable(uri))

#getURI("http://wonder.cdc.gov/mmwr/mmwrmort.asp")


get.mortality <- function(table="4A", year=2010, week=10, location="Boston, Mass.")  {
  uri <- htmlParse(getForm("http://wonder.cdc.gov/mmwr/mmwr_reps.asp",
                 mmwr_table="4A", mmwr_year=2010, mmwr_week=10, mmwr_location="Boston, Mass."))
  final.data <- data.frame(readHTMLTable(uri, header=T) [8])[-1,]
  col.names <- c("MMWR Week", "All Ages**", ">=65", "45-64", "25-44", "1-24", "Less than 1", "Pneumonia and Influenza")
  colnames(final.data) <- col.names
  rownames(final.data) <- c(1:52)
  final.data
}

get.mortality(year=2011, week=20, location="Boston, Mass.")
