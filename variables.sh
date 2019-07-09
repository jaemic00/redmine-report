#Overwriting variables for convenience (they have safe defaults)
export PGHOST=${PGHOST-localhost}
export PGPORT=${PGPORT-5432}
export PGDATABASE=${PGDATABASE-redmine}
export PGUSER=${PGUSER-redmine}
export PGPASSWORD=${PGPASSWORD-secret}