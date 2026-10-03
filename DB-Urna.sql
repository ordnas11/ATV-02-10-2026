CREATE DATABASE urna_eletronica;

USE urna_eletronica;


-- ============================================
-- TABELA PARTIDO
-- ============================================

CREATE TABLE partido (
    numero_partido INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(20) NOT NULL,

    CONSTRAINT pk_partido
        PRIMARY KEY (numero_partido),

    CONSTRAINT uq_partido_sigla
        UNIQUE (sigla),

    CONSTRAINT ck_partido_numero
        CHECK (numero_partido > 0)
);


-- ============================================
-- TABELA CANDIDATO
-- ============================================

CREATE TABLE candidato (
    numero_candidato INT NOT NULL,
    nome_completo VARCHAR(150) NOT NULL,
    cargo VARCHAR(30) NOT NULL,
    uf CHAR(2) NOT NULL,
    numero_partido INT NOT NULL,

    CONSTRAINT pk_candidato
        PRIMARY KEY (numero_candidato),

    CONSTRAINT fk_candidato_partido
        FOREIGN KEY (numero_partido)
        REFERENCES partido(numero_partido),

    CONSTRAINT ck_candidato_numero
        CHECK (numero_candidato > 0),

    CONSTRAINT ck_candidato_cargo
        CHECK (
            cargo IN (
                'Deputado Federal',
                'Deputado Estadual',
                'Senador',
                'Governador',
                'Presidente da Republica'
            )
        ),

    CONSTRAINT ck_candidato_uf
        CHECK (
            (cargo = 'Presidente da Republica' AND uf = 'BR')
            OR
            (cargo <> 'Presidente da Republica' AND uf <> 'BR')
        )
);


-- ============================================
-- TABELA ELEITOR
-- ============================================

CREATE TABLE eleitor (
    numero_titulo BIGINT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    rg VARCHAR(20) NOT NULL,
    uf CHAR(2) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    zona INT NOT NULL,
    secao INT NOT NULL,

    CONSTRAINT pk_eleitor
        PRIMARY KEY (numero_titulo),

    CONSTRAINT uq_eleitor_rg
        UNIQUE (rg),

    CONSTRAINT ck_eleitor_titulo
        CHECK (numero_titulo > 0),

    CONSTRAINT ck_eleitor_zona
        CHECK (zona > 0),

    CONSTRAINT ck_eleitor_secao
        CHECK (secao > 0)
);


-- ============================================
-- TABELA REGISTRO DE PRESENÇA
-- ============================================

CREATE TABLE registro_presenca (
    numero_titulo BIGINT NOT NULL,
    data_hora DATETIME NOT NULL,

    CONSTRAINT pk_registro_presenca
        PRIMARY KEY (numero_titulo),

    CONSTRAINT fk_presenca_eleitor
        FOREIGN KEY (numero_titulo)
        REFERENCES eleitor(numero_titulo)
);


-- ============================================
-- TABELA VOTO
-- ============================================

CREATE TABLE voto (
    id_voto BIGINT NOT NULL AUTO_INCREMENT,
    data_hora DATETIME NOT NULL,
    numero_candidato INT NOT NULL,

    CONSTRAINT pk_voto
        PRIMARY KEY (id_voto),

    CONSTRAINT fk_voto_candidato
        FOREIGN KEY (numero_candidato)
        REFERENCES candidato(numero_candidato)
);