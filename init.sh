#!/bin/bash

# =========================
# CONFIGURAÇÕES
# =========================
export PGPASSWORD="postgres"
export PGCLIENTENCODING="UTF8"

PG_HOST="localhost"
PG_PORT="5432"
PG_USER="postgres"
PG_DB="lab_bd"

PSQL="psql -h $PG_HOST -p $PG_PORT -U $PG_USER"

# =========================
# AGUARDAR POSTGRES INICIAR
# =========================
echo "Aguardando PostgreSQL iniciar..."

until $PSQL -d postgres -c '\q' 2>/dev/null; do
  echo "Ainda não está pronto..."
  sleep 2
done

echo "PostgreSQL está pronto"

# =========================
# RESETAR BANCO
# =========================
echo "Resetando banco de dados..."

# Derruba conexões ativas (necessário para DROP DATABASE funcionar)
$PSQL -d postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '$PG_DB' AND pid <> pg_backend_pid();
"

# Remove o banco se existir
$PSQL -d postgres -c "DROP DATABASE IF EXISTS $PG_DB;"

# Cria novamente
$PSQL -d postgres -c "CREATE DATABASE $PG_DB;"

# =========================
# CRIAR TABELAS
# =========================
echo "Criando tabelas..."
$PSQL -d $PG_DB -f ./trabalho3/create_table.sql
if [ $? -ne 0 ]; then
  echo "Erro ao criar tabelas"
  exit 1
fi

# =========================
# INSERIR DADOS
# =========================
echo "Inserindo dados..."
$PSQL -d $PG_DB -f ./trabalho3/insert_table.sql
if [ $? -ne 0 ]; then
  echo "Erro ao inserir dados"
  exit 1
fi

# =========================
# ALTERAR DADOS
# =========================
echo "Alterando dados..."
$PSQL -d $PG_DB -f ./trabalho3/alter_table.sql
if [ $? -ne 0 ]; then
  echo "Erro ao alterar dados"
  exit 1
fi

# =========================
# FINAL
# =========================
echo "Banco resetado e populado com sucesso"