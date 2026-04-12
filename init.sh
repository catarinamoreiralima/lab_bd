#!/bin/bash
 
export PGPASSWORD="postgres"
export PGCLIENTENCODING="UTF8"
 
PG_HOST="localhost"
PG_PORT="5432"
PG_USER="postgres"
PG_DB="lab_bd"
 
PSQL="psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DB"
 
echo "Criando tabelas..."
$PSQL -f ./trabalho3/create_table.sql
if [ $? -ne 0 ]; then exit 1; fi
 
echo "Inserindo dados..."
$PSQL -f ./trabalho3/insert_table.sql
if [ $? -ne 0 ]; then exit 1; fi
 
echo "Pronto!"