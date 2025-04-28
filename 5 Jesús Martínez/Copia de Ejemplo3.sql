DECLARE
    e_LibroDuplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_LibroDuplicado, -1); -- Código para "clave duplicada"
BEGIN
    insert into books (catalog_number, title) values (1000, 'Libro Repetido');
EXCEPTION
    when e_LibroDuplicado then
        insert into log_table (info) values ('Error: Catalog_number(id) duplicado en books.');
END;

select * from log_table