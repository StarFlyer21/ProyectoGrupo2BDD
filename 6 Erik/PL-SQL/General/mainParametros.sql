DECLARE
 v_in NUMBER := 3;
 v_out NUMBER;
 v_inout NUMBER := 5;

BEGIN
 DBMS_OUTPUT.PUT_LINE('Valores de las variables:');
 DBMS_OUTPUT.PUT_LINE('v_in = '||v_in||', v_out = '|| NVL(TO_CHAR(v_out), 'NULL') ||' , v_inout ='|| v_inout);
 pruebaParametros (v_in, v_out, v_inout);
 DBMS_OUTPUT.PUT_LINE('Valores de las variables después de procedimiento:');
 DBMS_OUTPUT.PUT_LINE('v_in = '||v_in||', v_out = '|| v_out ||' , v_inout ='|| v_inout);
END;