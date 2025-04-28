set serveroutput on;
DECLARE
  v_name  students.first_name%TYPE;
BEGIN
    SELECT first_name
    INTO v_name
    FROM students
   WHERE id = 10000;

   DBMS_OUTPUT.PUT_LINE('Hola, ' || v_name || '! Bienvenido.');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Estudiante no encontrado.');
END;
/