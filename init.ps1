$env:PGPASSWORD = "postgres"
$env:PGCLIENTENCODING = "UTF8"

$PG_HOST = "localhost"
$PG_PORT = "5432"
$PG_USER = "postgres"
$PG_DB   = "lab_bd"

$PSQL = "psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DB "

Write-Host "Reiniciando banco de dados..."
docker compose down -v
if ($LASTEXITCODE -ne 0) { exit 1 }
docker compose up -d
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Aguardando o banco subir..."
Start-Sleep -Seconds 3

Write-Host "Criando tabelas..."
Invoke-Expression "$PSQL -f ./trabalho3/create_table.sql"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Inserindo dados..."
Invoke-Expression "$PSQL -f ./trabalho3/insert_table.sql"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Alterando dados para essa entrega..."
Invoke-Expression "$PSQL -f ./trabalho3/alter_table.sql"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Pronto!"