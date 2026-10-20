
# Análise de Contratações Públicas do Governo Federal

Projeto de análise de dados do Portal Nacional de Contratações Públicas (PNCP), desenvolvido com Python, MySQL e Power BI.

## Objetivo

Analisar contratações públicas com foco em gastos governamentais, fornecedores, modalidades de contratação, distribuição regional, prazos e economia potencial.

## Tecnologias

- Python e Pandas
- MySQL e SQL
- Power BI e DAX
- Git e GitHub

## Estrutura do projeto

- `data/raw/`: arquivos brutos fornecidos para a análise.
- `data/processed/`: dados processados gerados pelos scripts.
- `src/`: scripts Python para limpeza, transformação e preparação dos dados.
- `sql/`: scripts SQL para criação das tabelas e consultas analíticas.
- `powerbi/`: arquivos do relatório Power BI.

## Etapas do projeto

1. Diagnóstico e preparação dos dados.
2. Limpeza e padronização.
3. Aplicação das regras de negócio e auditoria dos itens rejeitados.
4. Modelagem dimensional e carga no MySQL.
5. Consultas SQL e análise de negócio.
6. Desenvolvimento do dashboard no Power BI.
7. Documentação e entrega final.

## Auditoria e validação dos dados

A preparação dos dados é realizada com Python e Pandas. Os itens são avaliados conforme os critérios de validade definidos no enunciado do projeto. Quando um item se enquadra em mais de um critério, é contabilizado somente pelo primeiro motivo aplicável, respeitando a ordem das regras.

### Resultado da auditoria

Na execução atual do script de montagem das tabelas, foram identificados:

- **6.225 itens** com resultado, antes da aplicação das regras de rejeição.
- **99 itens rejeitados**, que não entram na tabela fato.
- **6.126 itens** mantidos na tabela fato.

### Motivos das rejeições

| Motivo                                                          |   Quantidade |
| --------------------------------------------------------------- | -----------: |
| Valor total estimado menor que R$ 1                             |           59 |
| Valor unitário estimado inválido (ausente ou não positivo)   |           23 |
| Valor homologado superior a 1.000 vezes o estimado              |            7 |
| Valor unitário homologado inválido (ausente ou não positivo) |            6 |
| Valor total estimado ou homologado acima de R$ 1 trilhão       |            3 |
| Quantidade inválida (ausente ou não positiva)                 |            1 |
| **Total**                                                 | **99** |

Os itens sem resultado homologado são tratados separadamente e não são contabilizados como rejeições nessa etapa.

### Conferência com os números de referência

Os resultados da execução foram comparados com o Anexo 8 do enunciado. Os principais indicadores conferidos foram:

| Indicador                         |           Resultado |
| --------------------------------- | ------------------: |
| Itens na tabela fato              |               6.126 |
| Contratações distintas          |               1.962 |
| Fornecedores distintos            |               2.652 |
| Órgãos distintos (CNPJ)         |                 363 |
| Volume homologado                 | R$ 8.044.498.805,74 |
| Itens comparáveis                |               5.457 |
| Economia sobre itens comparáveis |              14,46% |
| Ciclo médio de contratação     |           48,1 dias |
| Ciclo máximo de contratação    |            611 dias |
| Itens sem ciclo calculável       |                 230 |

A distribuição do volume homologado por perfil também corresponde aos valores de referência: Obras e engenharia (60,8%), Serviços (36,6%) e Bens (2,6%).

## Status

Em desenvolvimento.

Os resultados documentados correspondem às etapas já executadas e conferidas. A modelagem e a carga no MySQL, as consultas analíticas e o dashboard no Power BI ainda serão documentados conforme forem implementados e validados.

## Execução

Com o ambiente virtual configurado e as dependências instaladas, execute a montagem das tabelas processadas a partir da raiz do projeto:

```bash
python -m src.montar_tabelas
```

O script apresenta os totais da auditoria e os indicadores utilizados na conferência com o Anexo 8 do enunciado.
