CREATE OR REPLACE FUNCTION nombre_funcion [(nombreParámetro IN/OUT/IN OUT tipoDeDatos)]
RETURN tipoDeDatos
IS
  -- Sección declarativa (Variables, cursores, etc..)
BEGIN
  -- Sección ejecutable (Cuerpo del programa)
  RETURN valor; -- Se debe retornar un valor
EXCEPTION (en caso de necesitarlo)
  -- Manejo de excepciones
END nombre_funcion;
