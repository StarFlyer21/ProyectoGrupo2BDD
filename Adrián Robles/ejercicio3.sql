DECLARE
  v_EmpNombre Empleado.nombre%TYPE := 'WILLIAM SWING';   -- Usa %TYPE para coincidir con la columna
  v_AumentoSueldo Empleado.sueldo%TYPE := 100.50;
BEGIN
  -- Actualiza el sueldo del empleado
  UPDATE Empleado
  SET sueldo = sueldo + v_AumentoSueldo
  WHERE nombre = v_EmpNombre;

  -- Verifica si se actualizó alguna fila
  IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró empleado con nombre ' || v_EmpNombre);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Sueldo actualizado para ' || v_EmpNombre || '. Filas afectadas: ' || SQL%ROWCOUNT);
  END IF;

  -- Confirma los cambios
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK;
END;
/
