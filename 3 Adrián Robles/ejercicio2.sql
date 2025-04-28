DECLARE
  v_EmpRecord Empleado%ROWTYPE;
  v_NewID     Empleado.numemp%TYPE;
BEGIN
  -- Punto de restauración por si algo falla
  SAVEPOINT inicio_operacion;

  -- Obtener el siguiente ID disponible
  SELECT NVL(MAX(numemp), 0) + 1 INTO v_NewID FROM Empleado;

  -- Insertar nuevo empleado
  INSERT INTO Empleado (numemp, nombre, edad)
  VALUES (v_NewID, 'Ana Torres', 30);

  -- Seleccionar datos insertados
  SELECT *
  INTO v_EmpRecord
  FROM Empleado
  WHERE numemp = v_NewID;

  DBMS_OUTPUT.PUT_LINE('Empleado insertado:');
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_EmpRecord.nombre);
  DBMS_OUTPUT.PUT_LINE('Edad: ' || v_EmpRecord.edad);

  -- Actualizar la edad
  UPDATE Empleado
  SET edad = edad + 1
  WHERE numemp = v_NewID;

  -- Volver a leer el empleado actualizado
  SELECT *
  INTO v_EmpRecord
  FROM Empleado
  WHERE numemp = v_NewID;

  DBMS_OUTPUT.PUT_LINE('Empleado actualizado:');
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_EmpRecord.nombre);
  DBMS_OUTPUT.PUT_LINE('Edad: ' || v_EmpRecord.edad);

  -- Confirmar los cambios
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró el empleado con ID ' || v_NewID);
    ROLLBACK TO inicio_operacion;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK TO inicio_operacion;
END;
/
