
USE pncp_controladoria;

-- ============================================================
-- PROJETO: ANALISE DE CONTRATACOES PUBLICAS - PNCP
-- Arquivo: 02_perguntas.sql
-- Objetivo: responder as seis perguntas de negocio do projeto
-- ============================================================


-- ============================================================
-- PERGUNTA 1
-- Economia global do Poder Publico
-- Economia nominal e percentual dos itens comparaveis.
-- ============================================================

SELECT
    COUNT(*) AS total_itens_comparaveis,
    ROUND(SUM(valor_total_estimado), 2) AS total_estimado,
    ROUND(SUM(valor_total_homologado), 2) AS total_homologado,
    ROUND(SUM(economia_valor), 2) AS economia_nominal,
    ROUND(
        100 * SUM(economia_valor)
        / NULLIF(SUM(valor_total_estimado), 0),
        2
    ) AS economia_percentual
FROM fato_item_contratado
WHERE comparavel = 1;


-- ============================================================
-- PERGUNTA 2
-- Concentracao e risco de fornecedores
-- Ranking por volume homologado e participacao no total.
-- ============================================================

SELECT
    f.nome_fornecedor,
    f.ni_fornecedor,
    COUNT(*) AS quantidade_itens,
    ROUND(SUM(fc.valor_total_homologado), 2) AS volume_homologado,
    ROUND(
        100 * SUM(fc.valor_total_homologado)
        / NULLIF(t.total_homologado, 0),
        2
    ) AS participacao_percentual
FROM fato_item_contratado AS fc
JOIN dim_fornecedor AS f
    ON fc.sk_fornecedor = f.sk_fornecedor
CROSS JOIN (
    SELECT SUM(valor_total_homologado) AS total_homologado
    FROM fato_item_contratado
) AS t
GROUP BY
    f.sk_fornecedor,
    f.nome_fornecedor,
    f.ni_fornecedor,
    t.total_homologado
ORDER BY volume_homologado DESC
LIMIT 20;


-- ============================================================
-- PERGUNTA 3
-- Eficacia por modalidade
-- Volume financeiro e economia dos itens comparaveis.
-- ============================================================

SELECT
    m.nome_modalidade,
    COUNT(*) AS total_itens,
    ROUND(SUM(fc.valor_total_homologado), 2) AS volume_homologado,
    SUM(fc.comparavel) AS itens_comparaveis,
    ROUND(
        SUM(
            CASE
                WHEN fc.comparavel = 1
                THEN fc.valor_total_estimado
                ELSE 0
            END
        ),
        2
    ) AS total_estimado_comparavel,
    ROUND(
        SUM(
            CASE
                WHEN fc.comparavel = 1
                THEN fc.valor_total_homologado
                ELSE 0
            END
        ),
        2
    ) AS total_homologado_comparavel,
    ROUND(SUM(fc.economia_valor), 2) AS economia_nominal,
    ROUND(
        100 * SUM(fc.economia_valor)
        / NULLIF(
            SUM(
                CASE
                    WHEN fc.comparavel = 1
                    THEN fc.valor_total_estimado
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS economia_percentual
FROM fato_item_contratado AS fc
JOIN dim_modalidade AS m
    ON fc.sk_modalidade = m.sk_modalidade
GROUP BY m.sk_modalidade, m.nome_modalidade
ORDER BY volume_homologado DESC;


-- ============================================================
-- PERGUNTA 4
-- Tempo do ciclo de compras
-- Duracao media entre publicacao e homologacao por orgao.
-- ============================================================

SELECT
    o.nome_orgao,
    o.cnpj_orgao,
    COUNT(fc.dias_ciclo) AS ciclos_validos,
    ROUND(AVG(fc.dias_ciclo), 2) AS media_dias_ciclo,
    MIN(fc.dias_ciclo) AS menor_ciclo_dias,
    MAX(fc.dias_ciclo) AS maior_ciclo_dias
FROM fato_item_contratado AS fc
JOIN dim_orgao AS o
    ON fc.sk_orgao = o.sk_orgao
WHERE fc.dias_ciclo IS NOT NULL
GROUP BY o.sk_orgao, o.nome_orgao, o.cnpj_orgao
ORDER BY media_dias_ciclo DESC;


-- ============================================================
-- PERGUNTA 5
-- Distribuicao regional
-- Volume homologado e economia dos itens comparaveis por UF.
-- ============================================================

SELECT
    l.regiao,
    l.uf_sigla,
    l.uf_nome,
    COUNT(*) AS total_itens,
    ROUND(SUM(fc.valor_total_homologado), 2) AS volume_homologado,
    SUM(fc.comparavel) AS itens_comparaveis,
    ROUND(SUM(fc.economia_valor), 2) AS economia_nominal,
    ROUND(
        100 * SUM(fc.economia_valor)
        / NULLIF(
            SUM(
                CASE
                    WHEN fc.comparavel = 1
                    THEN fc.valor_total_estimado
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS economia_percentual
FROM fato_item_contratado AS fc
JOIN dim_localidade AS l
    ON fc.sk_localidade = l.sk_localidade
GROUP BY l.regiao, l.uf_sigla, l.uf_nome
ORDER BY volume_homologado DESC;


-- Visao consolidada por regiao
SELECT
    l.regiao,
    COUNT(*) AS total_itens,
    ROUND(SUM(fc.valor_total_homologado), 2) AS volume_homologado,
    SUM(fc.comparavel) AS itens_comparaveis,
    ROUND(SUM(fc.economia_valor), 2) AS economia_nominal,
    ROUND(
        100 * SUM(fc.economia_valor)
        / NULLIF(
            SUM(
                CASE
                    WHEN fc.comparavel = 1
                    THEN fc.valor_total_estimado
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS economia_percentual
FROM fato_item_contratado AS fc
JOIN dim_localidade AS l
    ON fc.sk_localidade = l.sk_localidade
GROUP BY l.regiao
ORDER BY volume_homologado DESC;


-- ============================================================
-- PERGUNTA 6
-- Perfil dos gastos
-- Distribuicao do volume homologado entre bens, servicos e obras.
-- ============================================================

SELECT
    fc.perfil_gasto,
    COUNT(*) AS total_itens,
    ROUND(SUM(fc.valor_total_homologado), 2) AS volume_homologado,
    ROUND(
        100 * SUM(fc.valor_total_homologado)
        / NULLIF(t.total_homologado, 0),
        2
    ) AS participacao_percentual
FROM fato_item_contratado AS fc
CROSS JOIN (
    SELECT SUM(valor_total_homologado) AS total_homologado
    FROM fato_item_contratado
) AS t
GROUP BY fc.perfil_gasto, t.total_homologado
ORDER BY volume_homologado DESC;
