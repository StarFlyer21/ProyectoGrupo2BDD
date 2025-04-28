BEGIN
    DECLARE
        estado VARCHAR2(10);
        v_num_aloj VARCHAR2(10) := 2;
    BEGIN
        estado := esCercano(v_num_aloj);
        DBMS_OUTPUT.PUT_LINE('El alojamiento ' || v_num_aloj || ' está ' || estado);
    END;
END;