DECLARE
    v_nombre_empleado VARCHAR2(50) := 'Pepe';
BEGIN
    insertaEmpleado(20, v_nombre_empleado, 30, 1, 2.5);
    DBMS_OUTPUT.PUT_LINE('Se añadió el empleado '|| v_nombre_empleado );
END;