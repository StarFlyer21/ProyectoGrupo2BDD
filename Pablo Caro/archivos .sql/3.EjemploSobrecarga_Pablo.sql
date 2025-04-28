-- ============================================
-- Especificación del paquete (declaraciones públicas)
-- ============================================
CREATE OR REPLACE PACKAGE GestionProfesores AS
  -- Procedimiento para buscar un profesor por su código
  PROCEDURE BuscarProfesor(p_Codigo IN profesores.codprofesor%TYPE);
  
  -- Procedimiento para buscar un profesor por su nombre
  PROCEDURE BuscarProfesor(p_Nombre IN profesores.nombre%TYPE);
END GestionProfesores;
/
-- ============================================
-- Cuerpo del paquete (implementación de los procedimientos)
-- ============================================
CREATE OR REPLACE PACKAGE BODY GestionProfesores AS

  -- Procedimiento que busca por código
  PROCEDURE BuscarProfesor(p_Codigo IN profesores.codprofesor%TYPE) IS
    v_Nombre profesores.nombre%TYPE;
  BEGIN
    SELECT nombre INTO v_Nombre
    FROM profesores
    WHERE codprofesor = p_Codigo;
    
    DBMS_OUTPUT.PUT_LINE('Profesor encontrado: ' || v_Nombre);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No existe profesor con código ' || p_Codigo);
  END BuscarProfesor;

  -- Procedimiento que busca por nombre
  PROCEDURE BuscarProfesor(p_Nombre IN profesores.nombre%TYPE) IS
    v_Codigo profesores.codprofesor%TYPE;
  BEGIN
    SELECT codprofesor INTO v_Codigo
    FROM profesores
    WHERE nombre = p_Nombre;
    
    DBMS_OUTPUT.PUT_LINE('Profesor encontrado. Código: ' || v_Codigo);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No existe profesor con nombre ' || p_Nombre);
  END BuscarProfesor;

BEGIN
  -- Sección de inicialización
  DBMS_OUTPUT.PUT_LINE('El paquete GestionProfesores (BuscarProfesor) ha sido cargado correctamente.');
END GestionProfesores;
/

-- ===================================================
-- PRUEBAS: Buscar un profesor por código y por nombre
-- ===================================================

-- Buscar profesor por código
BEGIN
  GestionProfesores.BuscarProfesor(1); -- Cambia 1 por un código que exista
  GestionProfesores.BuscarProfesor(69); --Salta el error
END;
/

-- Buscar profesor por nombre
BEGIN
  GestionProfesores.BuscarProfesor('Pablo Motos'); -- Cambia 'Pablo Motos' por un nombre que exista
  GestionProfesores.BuscarProfesor('Julio'); --Salta el error
END;
/

