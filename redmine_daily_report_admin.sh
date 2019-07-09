#!/bin/bash
#Daily admin report - all projects, all tasks, all users

#Variable that holds today's date for the message subject
now=$(date +"%d_%m_%Y")
#Variable that holds the message subject and info about the report
SUBJECT="Redmine Daily Report: $now"
INFO="This report contains all the time entries for all projects and all tasks logged by all users on $now"
#This is the psql command that includes the sql query.
PSQL_COMMAND_STRING="Copy (select projects.name as \"NazwaProjektu\", concat(users.firstname, users.lastname) as \"Użytkownik\", issues.subject as \"Zagadnienie\", time_entries.spent_on as \"Data\", time_entries.hours as \"Liczba godzin\", time_entries.comments as \"Komentarz\" from time_entries inner join issues on issues.id = time_entries.issue_id inner join users on users.id = time_entries.user_id inner join projects on projects.id = time_entries.project_id WHERE time_entries.spent_on = CAST(CURRENT_TIMESTAMP AS DATE) order by projects.id, users.id, time_entries.spent_on asc) To STDOUT With CSV HEADER DELIMITER ',';"
source sendReport.sh
