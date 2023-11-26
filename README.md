# Universidade - Sistema de Gerenciamento Acadêmico

Este é um sistema de gerenciamento acadêmico criado para a gestão de alunos, cursos, matrículas e áreas de estudo em uma universidade. O banco de dados foi desenvolvido utilizando MySQL e inclui tabelas para armazenar informações essenciais.

## Estrutura do Banco de Dados

### Tabelas:

1. **alunos**: Armazena dados dos alunos, como nome, sobrenome e email.
   ```sql
   CREATE TABLE alunos (
       id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
       nome VARCHAR(45),
       sobrenome VARCHAR(45),
       email VARCHAR(45)
   );


2. **áreas**:  Contém informações sobre as áreas de estudo disponíveis.
   ```sql
   CREATE TABLE areas (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nomeArea VARCHAR(45)
   );
   
