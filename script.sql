create schema universidade;

create table alunos (
    id int not null primary key auto_increment,
    nome varchar(45),
    sobrenome varchar(45),
   email varchar(45)
);

create table areas(
	id int not null primary key auto_increment,
    nomeArea varchar(45)
);

create table cursos (
	id int not null primary key auto_increment,
    nomeCurso varchar(45),
    area_id int not null,
    FOREIGN KEY (area_id) REFERENCES areas(id)
);

create table matriculas (
	id int not null primary key auto_increment,
    aluno_id int not null,
	FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    curso_id int not null,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);



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


INSERT INTO areas (nomeArea) VALUES ('Engenharia e Tecnologia');
INSERT INTO areas (nomeArea) VALUES ('Tecnologia da Informação');
INSERT INTO areas (nomeArea) VALUES ('Ciências Sociais Aplicadas');

CALL InserirCurso('Engenharia Mecânica', 1);
CALL InserirCurso('Engenharia Elétrica', 1);
CALL InserirCurso('Engenharia de Software', 2);
CALL InserirCurso('Banco de Dados', 2);
CALL InserirCurso('Administração de Empresas', 3);

CALL InserirAluno('Joao', 'Silva');
CALL InserirAluno('Maria', 'Santos');
CALL InserirAluno('Pedro', 'Ferreira');

CALL FazerMatricul('Joao', 'Silva', 'Engenharia Mecânica', 'Engenharia e Tecnologia');
CALL FazerMatricul('Maria', 'Santos', 'Engenharia Elétrica', 'Engenharia e Tecnologia');
CALL FazerMatricul('Pedro', 'Ferreira', 'Administração de Empresas', 'Ciências Sociais Aplicadas');



