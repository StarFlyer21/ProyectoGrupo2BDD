set serveroutput on;
DECLARE
  nombre  students.first_name%TYPE;
BEGIN
    SELECT first_name
    INTO nombre
    FROM students
   WHERE id = 10000;

   DBMS_OUTPUT.PUT_LINE('Hola, ' || nombre || '! Bienvenido.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Estudiante no encontrado.');
END;
/