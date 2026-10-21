
CREATE DATABASE IF NOT EXISTS pncp_controladoria;
USE pncp_controladoria;

CREATE TABLE IF NOT EXISTS dim_orgao (
    sk_orgao INT NOT NULL,
    cnpj_orgao VARCHAR(20) NOT NULL,
    nome_orgao VARCHAR(255) NOT NULL,
    poder VARCHAR(100),
    PRIMARY KEY (sk_orgao),
    UNIQUE KEY uq_dim_orgao_cnpj (cnpj_orgao)
);

CREATE TABLE IF NOT EXISTS dim_fornecedor (
    sk_fornecedor INT NOT NULL,
    ni_fornecedor VARCHAR(20) NOT NULL,
    nome_fornecedor VARCHAR(255),
    tipo_pessoa VARCHAR(50),
    porte VARCHAR(100),
    PRIMARY KEY (sk_fornecedor),
    UNIQUE KEY uq_dim_fornecedor_ni (ni_fornecedor)
);

CREATE TABLE IF NOT EXISTS dim_modalidade (
    sk_modalidade INT NOT NULL,
    modalidade_id INT,
    nome_modalidade VARCHAR(150) NOT NULL,
    PRIMARY KEY (sk_modalidade),
    UNIQUE KEY uq_dim_modalidade_id (modalidade_id)
);

CREATE TABLE IF NOT EXISTS dim_localidade (
    sk_localidade INT NOT NULL,
    uf_sigla CHAR(2) NOT NULL,
    uf_nome VARCHAR(100) NOT NULL,
    regiao VARCHAR(50) NOT NULL,
    PRIMARY KEY (sk_localidade),
    UNIQUE KEY uq_dim_localidade_uf (uf_sigla)
);

CREATE TABLE IF NOT EXISTS fato_item_contratado (
    sk_fato INT NOT NULL AUTO_INCREMENT,
    numero_controle_pncp VARCHAR(60) NOT NULL,
    numero_item INT NOT NULL,

    sk_orgao INT NOT NULL,
    sk_fornecedor INT NOT NULL,
    sk_modalidade INT NOT NULL,
    sk_localidade INT NOT NULL,

    data_publicacao DATE,
    data_homologacao DATE,
    descricao_item TEXT,
    perfil_gasto VARCHAR(100),

    quantidade DECIMAL(18,4) NOT NULL,
    valor_unitario_estimado DECIMAL(18,4) NOT NULL,
    valor_total_estimado DECIMAL(18,2) NOT NULL,
    valor_unitario_homologado DECIMAL(18,4) NOT NULL,
    valor_total_homologado DECIMAL(18,2) NOT NULL,

    comparavel TINYINT NOT NULL,
    economia_valor DECIMAL(18,2),
    dias_ciclo INT,

    PRIMARY KEY (sk_fato),
    UNIQUE KEY uq_fato_item (numero_controle_pncp, numero_item),

    CONSTRAINT fk_fato_orgao
        FOREIGN KEY (sk_orgao) REFERENCES dim_orgao (sk_orgao),
    CONSTRAINT fk_fato_fornecedor
        FOREIGN KEY (sk_fornecedor) REFERENCES dim_fornecedor (sk_fornecedor),
    CONSTRAINT fk_fato_modalidade
        FOREIGN KEY (sk_modalidade) REFERENCES dim_modalidade (sk_modalidade),
    CONSTRAINT fk_fato_localidade
        FOREIGN KEY (sk_localidade) REFERENCES dim_localidade (sk_localidade),

    CONSTRAINT chk_fato_quantidade
        CHECK (quantidade > 0),
    CONSTRAINT chk_fato_valores
        CHECK (
            valor_unitario_estimado >= 0
            AND valor_total_estimado >= 0
            AND valor_unitario_homologado >= 0
            AND valor_total_homologado >= 0
        ),
    CONSTRAINT chk_fato_comparavel
        CHECK (comparavel IN (0, 1))
);
