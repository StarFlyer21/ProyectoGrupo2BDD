DECLARE
  TYPE t_datos_estudiantes IS TABLE OF students%ROWTYPE 
    INDEX BY BINARY_INTEGER;
  v_students  t_datos_estudiantes;
BEGIN
  -- Almacenar al estudiante con ID 10000
  SELECT * INTO v_students(10000) 
  FROM students WHERE id = 10000;
  
  -- Añadir manualmente un nuevo estudiante
  v_students(1001).first_name := 'Nuevo';
  v_students(1001).last_name := 'Estudiante';
END;