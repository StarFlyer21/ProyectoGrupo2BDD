declare
    v_nombre empleado.nombre%type;
    //declaramos una variable nombre para guardad el nombre del empleado
begin
    select nombre into v_nombre
    from empleado
    //buscamos el nombre de un empleado que tenga el numemp 1 y guardamos en v_nombre
    where numemp = 1;
     dbms_output.put_line('empleado: ' || v_nombre);
 end;