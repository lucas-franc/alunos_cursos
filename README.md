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


2. **areas**:  Contém informações sobre as áreas de estudo disponíveis.
   ```sql
   CREATE TABLE areas (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nomeArea VARCHAR(45)
   );
   
3. **cursos**:  Registra os cursos oferecidos, vinculados às respectivas áreas de estudo.
   ```sql
  CREATE TABLE cursos (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nomeCurso VARCHAR(45),
    area_id INT NOT NULL,
    FOREIGN KEY (area_id) REFERENCES areas(id)
);

4. **matriculas**:  Mantém o registro das matrículas dos alunos nos cursos.
   ```sql
  CREATE TABLE matriculas (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    curso_id INT NOT NULL,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

## Procedures e Functions

```sql
DELIMITER //

CREATE PROCEDURE InserirCurso (
    IN p_nomeCurso VARCHAR(45),
    IN p_area_id INT
)
BEGIN
    INSERT INTO cursos (nomeCurso, area_id)
    VALUES (p_nomeCurso, p_area_id);
END //

DELIMITER ;

```sql
DELIMITER //

CREATE PROCEDURE SelecionarCursosPorArea (
    IN p_area_id INT
)
BEGIN
    SELECT *
    FROM cursos
    WHERE area_id = p_area_id;
END //

DELIMITER ;

   ```sql
DELIMITER //

CREATE PROCEDURE InserirAluno (
    IN nomeAlunoParam VARCHAR(45),
    IN sobrenomeAlunoParam VARCHAR(45)
)
BEGIN
    DECLARE emailAlunoParam VARCHAR(45);

    SET emailAlunoParam = CONCAT(nomeAlunoParam, '.', sobrenomeAlunoParam,  '@facens.br');

    INSERT INTO alunos (nome, sobrenome, email)
    VALUES (nomeAlunoParam, sobrenomeAlunoParam, emailAlunoParam);
END //

DELIMITER ;

   ```sql
DELIMITER //

CREATE FUNCTION ObterIDdoCurso (
    p_nomeCurso VARCHAR(45),
    p_nomeArea VARCHAR(45)
)
RETURNS INT
BEGIN
    DECLARE cursoID INT;

    SELECT cursos.id INTO cursoID
    FROM cursos
    INNER JOIN areas ON cursos.area_id = areas.id
    WHERE cursos.nomeCurso = p_nomeCurso AND areas.nomeArea = p_nomeArea;

    RETURN cursoID;
END //

DELIMITER ;

   ```sql
DELIMITER //

CREATE PROCEDURE FazerMatricul (
    IN p_nomeAluno VARCHAR(45),
    IN p_sobrenomeAluno VARCHAR(45),
    IN p_nomeCurso VARCHAR(45),
    IN p_nomeArea VARCHAR(45)
)
BEGIN
    DECLARE alunoID INT;
    DECLARE cursoID INT;
    DECLARE matriculaExistente INT;


    SELECT id INTO alunoID FROM alunos WHERE nome = p_nomeAluno AND sobrenome = p_sobrenomeAluno;


    SELECT cursos.id INTO cursoID
    FROM cursos
    INNER JOIN areas ON cursos.area_id = areas.id
    WHERE cursos.nomeCurso = p_nomeCurso AND areas.nomeArea = p_nomeArea;


    SELECT COUNT(*) INTO matriculaExistente FROM matriculas WHERE aluno_id = alunoID;

    IF alunoID IS NOT NULL AND cursoID IS NOT NULL AND matriculaExistente = 0 THEN
        INSERT INTO matriculas (aluno_id, curso_id) VALUES (alunoID, cursoID);
        SELECT 'Matrícula realizada com sucesso!' AS Mensagem;
    ELSE
        SELECT 'Não foi possível realizar a matrícula. Verifique os dados informados ou o status de matrícula do aluno.' AS Mensagem;
    END IF;
END //

DELIMITER ;
   ```sql
DELIMITER //

CREATE PROCEDURE ConsultarMatriculasCursosAlunos()
BEGIN
    SELECT
        matriculas.id AS 'ID da Matrícula',
        cursos.nomeCurso AS 'Nome do Curso',
        CONCAT(alunos.nome, ' ', alunos.sobrenome) AS 'Nome do Aluno',
        alunos.email AS 'Email do Aluno'
    FROM
        matriculas
    INNER JOIN cursos ON matriculas.curso_id = cursos.id
    INNER JOIN alunos ON matriculas.aluno_id = alunos.id;
END //

DELIMITER ;
