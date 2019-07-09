#Loading variables from the variables.sh file
source variables.sh
source smtp_config.sh

#Variables that hold the current month's english name and the current year for the message subject
month=$(LANG=en_us_88591; date "+%B")
year=$(date +"%Y")
#Variable that holds the message subject and info about the report
SUBJECT="Redmine Personal Monthly Report: $month of $year"
INFO="This report contains all the time entries you submitted in $month, $year"
#Get user e-mails from the database
USEREMAILS=$(psql -c "Copy (SELECT string_agg(address, ',') FROM email_addresses) To STDOUT;")
#Generate an array of e-mails.
IFS=', ' read -r -a mails <<< "$USEREMAILS"
#Send a custom report to each user of his time entries.
for mail in "${mails[@]}"
do
    #This is the psql command that includes the sql query.
    PSQL_COMMAND_STRING="Copy (SELECT projects.name AS \"NazwaProjektu\", issues.subject AS \"Zagadnienie\", time_entries.spent_on AS \"Data\", time_entries.hours AS \"Liczba godzin\", time_entries.comments AS \"Komentarz\" from time_entries inner join issues ON issues.id = time_entries.issue_id inner join projects ON projects.id = time_entries.project_id inner join users ON time_entries.user_id = users.id inner join email_addresses ON email_addresses.user_id = users.id WHERE address='$mail' AND EXTRACT(month FROM time_entries.spent_on) = EXTRACT(month FROM CAST(CURRENT_TIMESTAMP AS DATE)) order by projects.id, users.id, time_entries.spent_on asc) To STDOUT With CSV HEADER DELIMITER ',';"
    source sendReport.sh user
done