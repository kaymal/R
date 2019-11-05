#
# Build and use a new SQLite database.
#
require (RSQLite)
m <- dbDriver ("SQLite")
#
# Connect
#
con <- dbConnect (m, dbname = file.choose())
#
# Copy Excel stuff to clipboard, read in, add to SQLite.
#
if (0) {
  designators <- read.delim ("clipboard")
  sqliteWriteTable (con, "Designators", designators)
  
  Students <- read.delim ("clipboard")
  sqliteWriteTable (con, "Students", Students)
  
  Theses <- read.delim ("clipboard")
  sqliteWriteTable (con, "Theses", Theses)
}
#
# List tables
#
dbListTables (con)
#
# Show tables: note the ExecStatment followed by the Fetch
#
sqliteFetch  (sqliteExecStatement (con, "select * from students"))

sqliteFetch  (sqliteExecStatement (con, "select * from theses"))

sqliteFetch  (sqliteExecStatement (con, "select * from designators"))

#
# Inner join: get me info from "students" for everyone from "thesis" who matches
#
sqliteFetch (sqliteExecStatement (con, "select theses.*, students.section 
                                  from theses, students
                                  where theses.LastName = Students.Last"))
#
# Another, more explicit way to do "inner join" (also called "natural join"").
#
sqliteFetch (sqliteExecStatement (con, "select theses.*, students.section from theses 
                                  inner join students 
                                  on theses.LastName = Students.Last"))
#
# Left join: get me one row per thesis, whether it matches or not
# me: 2 kisi section table im da olmadigi icin burada NA gozukuyor
sqliteFetch (sqliteExecStatement (con, "select theses.*, students.section from theses 
                                  left join students 
                                  on theses.LastName = Students.Last"))
#
# SQLite does not support right or full joins. But you can do an outer join using 
# UNION, which combines two results and discards duplicates, like this:
#
sqliteFetch (sqliteExecStatement (con, "select students.last, students.section, theses.LastName, theses.Topic
                                  from students left join theses 
                                  on theses.LastName = Students.Last
                                  union 
                                  select students.last, students.section, theses.LastName, theses.Topic
                                  from theses left join students
                                  on theses.LastName = Students.Last"))

sqliteCloseConnection(con)

#
###  HW - Accounts
#