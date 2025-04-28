CREATE OR REPLACE FUNCTION esCercano (p_num_aloj IN alojamiento.numaloj%TYPE) 
RETURN VARCHAR2
IS
    v_distancia NUMBER;
BEGIN
    SELECT distancia INTO v_distancia 
      FROM alojamiento 
     WHERE numaloj = p_num_aloj;
    IF v_distancia <= 20 THEN
        RETURN 'CERCA';
    ELSE
        RETURN 'LEJOS';
    END IF;
END esCercano;
