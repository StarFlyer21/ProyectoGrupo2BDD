CREATE OR REPLACE PROCEDURE pruebaParametros(
  p_in_param IN NUMBER,
  p_out_param OUT NUMBER,
  p_inout_param IN OUT NUMBER
) IS
BEGIN
  -- p_in_param solo se puede leer
  DBMS_OUTPUT.PUT_LINE('parametro "in": ' || p_in_param);

  -- p_out_param solo se puede escribir
  p_out_param := p_in_param * 2;

  -- p_inout_param se puede leer y escribir
  p_inout_param := p_inout_param + p_in_param;
END pruebaParametros;