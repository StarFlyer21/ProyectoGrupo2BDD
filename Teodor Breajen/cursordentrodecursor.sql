declare 
    cursor c_emp is select numemp, nombre from empleado;
    --declaramos un cursor c_emp que trae el numero y nombre de los empleados
    
        v_numemp empleado.numemp%type;
        v_nombre empleado.nombre%type;
        v_oficio oficio.oficio%type;
        --declaramos variables para el numero, nombre y oficio
        
    begin
        for emp in c_emp loop
        v_numemp := emp.numemp;
        v_nombre := emp.nombre;
        dbms_output.put_line('------------------------');
        dbms_output.put_line('empleado: ' ||v_nombre);
        
        --usamos un primer for para recorrer cada empleado
        
            for ofi in 
            (select o.oficio from oficioempleado oe
            join oficio o on oe.oficio = o.numoficio
            where oe.empleado = emp.numemp)
            --seleccionamos los oficios de un empleado ( este select actua como un cursor implicito)
            loop
            v_oficio := ofi.oficio;
            dbms_output.put_line(' oficio:' || v_oficio);
            end loop;
            --usamos un segundo for que hace un select de los oficios del empleado
        end loop;
end;
