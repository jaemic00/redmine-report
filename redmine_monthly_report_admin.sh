#!/bin/bash
#Monthly admin report - all projects, all tasks, all users

#Variabls that hold the current month's english name and the current year for the message subject
month=$(LANG=en_us_88591; date "+%B")
year=$(date +"%Y")
#Variable that holds the message subject and info about the report
SUBJECT="Redmine Monthly Report: $month of $year"
INFO="This report contains all the time entries for all projects and all tasks created by all users in $month, $year"
#This is the psql command that includes the sql query.
PSQL_COMMAND_STRING="Copy (select projects.name as \"NazwaProjektu\", concat(users.firstname, users.lastname) as \"Użytkownik\", issues.subject as \"Zagadnienie\", time_entries.spent_on as \"Data\", time_entries.hours as \"Liczba godzin\", time_entries.comments as \"Komentarz\" from time_entries inner join issues on issues.id = time_entries.issue_id inner join users on users.id = time_entries.user_id inner join projects on projects.id = time_entries.project_id WHERE EXTRACT(month FROM time_entries.spent_on) = EXTRACT(month FROM CAST(CURRENT_TIMESTAMP AS DATE)) order by projects.id, users.id, time_entries.spent_on asc) To STDOUT With CSV HEADER DELIMITER ',';"
source sendReport.sh