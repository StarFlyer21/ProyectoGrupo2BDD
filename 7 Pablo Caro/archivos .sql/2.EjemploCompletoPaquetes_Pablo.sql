-- ============================================
-- Especificación del paquete (declaraciones públicas)
-- ============================================
CREATE OR REPLACE PACKAGE GestionProfesores AS
  -- Procedimiento para insertar un nuevo profesor
  PROCEDURE NuevoProfesor(p_Nombre IN profesores.nombre%TYPE);
  
  -- Procedimiento para consultar el contador de profesores
  PROCEDURE VerContadorProfesores(p_Valor OUT NUMBER);
END GestionProfesores;
/
-- ============================================
-- Cuerpo del paquete (implementación)
-- ============================================
CREATE OR REPLACE PACKAGE BODY GestionProfesores AS

  -- Variable global para contar los profesores añadidos en esta sesión
  v_ContadorProfesores NUMBER := 0;

  -- Implementación del procedimiento NuevoProfesor
  PROCEDURE NuevoProfesor(p_Nombre IN profesores.nombre%TYPE) IS
    v_NuevoCodigo NUMBER;
  BEGIN
    -- Calcular el nuevo código: el mayor código actual + 1
    SELECT NVL(MAX(codprofesor), 0) + 1
    INTO v_NuevoCodigo
    FROM profesores;

    -- Insertar el nuevo profesor
    INSERT INTO profesores (codprofesor, nombre)
    VALUES (v_NuevoCodigo, p_Nombre);

    -- Aumentar el contador
    v_ContadorProfesores := v_ContadorProfesores + 1;
  END NuevoProfesor;

  -- Implementación del procedimiento VerContadorProfesores
  PROCEDURE VerContadorProfesores(p_Valor OUT NUMBER) IS
  BEGIN
    p_Valor := v_ContadorProfesores;
  END VerContadorProfesores;

BEGIN
  -- Sección de inicialización: se ejecuta al cargar el paquete
  DBMS_OUTPUT.PUT_LINE('El paquete GestionProfesores ha sido cargado correctamente.');
END GestionProfesores;
/
-- ============================================
-- PRUEBAS: Insertar un profesor y ver el contador
-- ============================================

-- Insertamos a Pablo Motos
BEGIN
  GestionProfesores.NuevoProfesor('Pablo Motos');
END;
/
COMMIT;
/

-- Comprobamos que se ha insertado
SELECT * FROM profesores;
/

-- Vemos el contador actual
DECLARE
  v_ProfesoresRegistrados NUMBER;
BEGIN
  GestionProfesores.VerContadorProfesores(v_ProfesoresRegistrados);
  DBMS_OUTPUT.PUT_LINE('Profesores registrados en esta sesión: ' || v_ProfesoresRegistrados);
END;
/
