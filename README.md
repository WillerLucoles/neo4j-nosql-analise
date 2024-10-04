# Análise de Dados com Neo4j

Este repositório contém o código e os resultados do trabalho prático de NoSQL utilizando **Neo4j** para análise de dados de uma rede social.

## Objetivos

1. Importação de arquivos JSON e criação de nós e arestas no banco de dados.
2. Descoberta da hashtag principal em tweets originais.
3. Análise de dados - Identificação do usuário mais ativo na rede.

## Tecnologias utilizadas

- **Neo4j**: Banco de dados orientado a grafos.
- **Cypher**: Linguagem de consulta para o Neo4j.
- **APOC**: Biblioteca de procedimentos auxiliares para Neo4j.

## Importação de Dados

Utilizamos a biblioteca APOC para importar arquivos JSON e criar nós de Tweets, Retweets, Respostas e Hashtags.
