CREATE VIEW Circuitos_completa AS
SELECT
    c.name AS nome_circuito,
    c.lat AS latitude,
    c.long AS longitude,
    ct.name AS nome_cidade,
    cn.name AS nome_pais,
    cn.code AS codigo_pais
FROM
    circuits c
LEFT JOIN
    cities ct ON c.city_id = ct.id
LEFT JOIN
    countries cn ON ct.country_id = cn.id;


-----------------------------------------
--- TESTES--------
-----------------------------------------

\echo '========================================================='
\echo 'TESTE 1 - Visualizar os circuitos completos'
\echo 'Resultado esperado: Lista de circuitos com nome, latitude, longitude, cidade, país e código do país.'
\echo '========================================================='   

SELECT * FROM Circuitos_completa
LIMIT 10;

\echo '========================================================='
\echo 'TESTE 2 - Total de tuplas'
\echo 'Resultado esperado: Total de circuitos listados.'
\echo '========================================================='

SELECT COUNT(*) AS total_circuitos FROM Circuitos_completa;

\echo '========================================================='
\echo 'TESTE 3 - Verificar circuitos sem cidade associada'
\echo 'Resultado esperado: Lista de circuitos que não possuem cidade associada.'
\echo '========================================================='   

SELECT * FROM Circuitos_completa
WHERE nome_cidade IS NULL;

