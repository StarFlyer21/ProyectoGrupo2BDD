DECLARE
  v_EmpRecord Empleado%ROWTYPE;  -- Registro basado en la estructura de la tabla Empleado
  v_EmpID Empleado.numemp%TYPE := 4; -- Nombre diferente a 'numemp' para evitar confusión
BEGIN
  -- Selecciona los detalles del empleado en el registro
  SELECT *
  INTO v_EmpRecord
  FROM Empleado
  WHERE numemp = v_EmpID;

  -- Muestra los detalles
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_EmpRecord.nombre);
  DBMS_OUTPUT.PUT_LINE('Edad: ' || v_EmpRecord.edad);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró empleado con ID ' || v_EmpID);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Error: Múltiples empleados encontrados');
END;
/
