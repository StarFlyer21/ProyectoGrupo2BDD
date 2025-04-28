declare
    cursor c_emp is select numemp, nombre from empleado;
    //declaramos el cursor c_emp que trael el numero y nombre de los empleados
    v_numemp empleado.numemp%type;
    v_nombre empleado.nombre%type;
    //declaramos dos variables para guardar numemp y nombre

begin
    for emp in c_emp loop
    v_numemp := emp.numemp;
    v_nombre := emp.nombre;
    dbms_output.put_line
    ('empleado: ' || v_nombre || 'nº identificación: ' || v_numemp);
    end loop;
    //recorremos cada empleado uno por uno con el for y copiamos el numero y nombre en las variables
end;
