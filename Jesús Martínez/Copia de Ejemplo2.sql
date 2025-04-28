DECLARE
    e_CursoVacio EXCEPTION;
    v_numeroAlumnos number(3);
BEGIN
    select count(*) into v_numeroAlumnos
    from registered_students
    where course = 202; -- Curso específico

    if v_numeroAlumnos < 3 then
        RAISE e_CursoVacio;
    end if;
EXCEPTION
    when e_CursoVacio then
        insert into log_table (info) valuess ('Curso con menos de 3 alumnos.');
END;

select * from log_table
