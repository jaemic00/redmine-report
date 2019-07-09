#Loading variables from the variables.sh file
source variables.sh
#Getting the administrator e-mails from the database
ADMINEMAILS=$(psql -c "Copy (SELECT string_agg(address, ',') FROM email_addresses INNER JOIN users ON users.id = email_addresses.user_id WHERE admin=true) To STDOUT;")
#If temp exists, delete it.
if [ -d "./temp" ]; then
  rm -r temp
fi
#Creating an empty temp directory
mkdir temp
#Exporting the query's result to a .csv file using psql with a comma as a default delimiter
psql -c "$PSQL_COMMAND_STRING" > ./temp/queryData.csv
#Building the html file:
#Appending the XTML doctype,head and styling from the messageHead.html file
cat messageHead.html >> ./temp/messageBody.html
#Adding headers with info about the report
echo "<h1>$SUBJECT</h1>" >> ./temp/messageBody.html
echo "<h2>$INFO</h2>" >> ./temp/messageBody.html
#Appending the HTML table generated from the query
./csv2html.sh ./temp/queryData.csv >> ./temp/messageBody.html
#Finishing the html tag
echo "</html>" >> ./temp/messageBody.html
#Sending the email
./sendEmail -f "witkowski.you2.pl@you2.pl" -t $ADMINEMAILS -u "$SUBJECT" -s "$SMTP_SERVER" -xu "$SMTP_USER" -xp "$SMTP_PASSWORD" -o message-content-type=html -o message-file="./temp/messageBody.html" -o message-charset=utf-8
#Removing the temp directory
rm -r temp