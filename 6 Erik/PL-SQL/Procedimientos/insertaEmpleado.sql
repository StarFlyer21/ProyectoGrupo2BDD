CREATE OR REPLACE PROCEDURE insertaEmpleado (
    p_numemp    empleado.numemp%TYPE,
    p_nombre    empleado.nombre%TYPE,
    p_edad      empleado.edad%TYPE,
    p_alojamiento      empleado.alojamiento%TYPE,
    p_sueldo    empleado.sueldo%TYPE) 
IS
BEGIN
    INSERT INTO empleado (numemp, nombre, edad, alojamiento, sueldo)
    VALUES (p_numemp, p_nombre, p_edad, p_alojamiento, p_sueldo);
    
END insertaEmpleado;
