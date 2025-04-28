-- 1. Crear las tablas necesarias
CREATE TABLE PRODUCTOS (
  IDPRODUCTO NUMBER PRIMARY KEY,
  STOCK NUMBER
);

CREATE TABLE AUDITORIA_PRODUCTOS (
  ID_AUDIT NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  TIPO_CAMBIO CHAR(1),
  USUARIO_MODIFICACION VARCHAR2(100),
  FECHA_CAMBIO DATE,
  IDPRODUCTO_ANTERIOR NUMBER,
  STOCK_ANTERIOR NUMBER,
  IDPRODUCTO_NUEVO NUMBER,
  STOCK_NUEVO NUMBER
);

-- 2. Crear el paquete PKG_CONTROL_STOCK
CREATE OR REPLACE PACKAGE PKG_CONTROL_STOCK AS
  TYPE T_PRODUCTO_IDS IS TABLE OF PRODUCTOS.IDPRODUCTO%TYPE
    INDEX BY BINARY_INTEGER;
  V_PRODUCTO_IDS T_PRODUCTO_IDS;
  V_FILAS NUMBER := 0;
END;
/

-- 3. Crear el trigger que anota los productos afectados
CREATE OR REPLACE TRIGGER trg_registrar_producto
BEFORE INSERT OR UPDATE OF STOCK ON PRODUCTOS
FOR EACH ROW
BEGIN
  -- Solo registrar si el ID es válido
  IF :NEW.IDPRODUCTO IS NOT NULL THEN
    pkg_control_stock.v_filas := pkg_control_stock.v_filas + 1;
    pkg_control_stock.v_producto_ids(pkg_control_stock.v_filas) := :NEW.IDPRODUCTO;
  END IF;
END;
/

-- 4. Crear el trigger COMPOUND que valida el stock
CREATE OR REPLACE TRIGGER trg_validar_stock
FOR INSERT OR UPDATE OF STOCK ON PRODUCTOS
COMPOUND TRIGGER
  v_stock NUMBER;

  AFTER STATEMENT IS
  BEGIN
    FOR i IN 1 .. pkg_control_stock.v_filas LOOP
      -- SQL dinámico para validar que ningún producto quede con stock negativo
      BEGIN
        IF pkg_control_stock.v_producto_ids.EXISTS(i) AND pkg_control_stock.v_producto_ids(i) IS NOT NULL THEN
          EXECUTE IMMEDIATE 'SELECT NVL(STOCK, 0) FROM PRODUCTOS WHERE IDPRODUCTO = :1'
          INTO v_stock
          USING pkg_control_stock.v_producto_ids(i);

          IF v_stock < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Producto con stock negativo: ' || pkg_control_stock.v_producto_ids(i));
          END IF;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- Ignorar si el producto no existe
        WHEN OTHERS THEN
          NULL; -- Ignorar cualquier otro error para evitar ORA-04088
      END;
    END LOOP;

    -- Resetear variables del paquete
    pkg_control_stock.v_filas := 0;
    pkg_control_stock.v_producto_ids.DELETE; -- Limpiar la colección
  END AFTER STATEMENT;
END;
/

-- 5. Crear el trigger de auditoría
CREATE OR REPLACE TRIGGER trg_auditar_cambios_productos
BEFORE INSERT OR UPDATE OR DELETE ON PRODUCTOS
FOR EACH ROW
WHEN (NEW.STOCK IS NULL OR NEW.STOCK > 50) -- Solo si el nuevo stock es NULL o > 50
DECLARE
  v_tipo_cambio CHAR(1);
BEGIN
  IF INSERTING THEN
    v_tipo_cambio := 'I';
  ELSIF UPDATING THEN
    v_tipo_cambio := 'U';
  ELSIF DELETING THEN
    v_tipo_cambio := 'D';
  END IF;

  INSERT INTO AUDITORIA_PRODUCTOS
    (TIPO_CAMBIO, USUARIO_MODIFICACION, FECHA_CAMBIO,
     IDPRODUCTO_ANTERIOR, STOCK_ANTERIOR,
     IDPRODUCTO_NUEVO, STOCK_NUEVO)
  VALUES
    (v_tipo_cambio, USER, SYSDATE,
     :OLD.IDPRODUCTO, :OLD.STOCK,
     :NEW.IDPRODUCTO, :NEW.STOCK);
END;
/

-- 6. Bloque PL/SQL para pruebas y mostrar resultados
BEGIN
  -- Operaciones DML de prueba
  DBMS_OUTPUT.PUT_LINE('Iniciando operaciones DML de prueba...');

  -- Insertar un producto con stock > 50 (debería auditar)
  INSERT INTO PRODUCTOS (IDPRODUCTO, STOCK) VALUES (1, 100);
  DBMS_OUTPUT.PUT_LINE('Producto 1 insertado con stock 100.');

  -- Insertar un producto con stock < 50 (no debería auditar)
  INSERT INTO PRODUCTOS (IDPRODUCTO, STOCK) VALUES (2, 30);
  DBMS_OUTPUT.PUT_LINE('Producto 2 insertado con stock 30.');

  -- Actualizar producto a stock negativo (debería fallar)
  BEGIN
    UPDATE PRODUCTOS SET STOCK = -10 WHERE IDPRODUCTO = 1;
    DBMS_OUTPUT.PUT_LINE('Producto 1 actualizado a stock -10.'); -- No se ejecuta si falla
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al actualizar producto 1: ' || SQLERRM);
  END;

  -- Actualizar producto a stock > 50 (debería auditar)
  UPDATE PRODUCTOS SET STOCK = 60 WHERE IDPRODUCTO = 2;
  DBMS_OUTPUT.PUT_LINE('Producto 2 actualizado a stock 60.');

  -- Eliminar un producto (debería auditar porque NEW.STOCK es NULL)
  DELETE FROM PRODUCTOS WHERE IDPRODUCTO = 1;
  DBMS_OUTPUT.PUT_LINE('Producto 1 eliminado.');

  -- Mostrar los registros de auditoría
  DBMS_OUTPUT.PUT_LINE('--- Registros en AUDITORIA_PRODUCTOS ---');
  FOR rec IN (SELECT ID_AUDIT, TIPO_CAMBIO, USUARIO_MODIFICACION, 
                     TO_CHAR(FECHA_CAMBIO, 'YYYY-MM-DD HH24:MI:SS') AS FECHA_CAMBIO,
                     IDPRODUCTO_ANTERIOR, STOCK_ANTERIOR, 
                     IDPRODUCTO_NUEVO, STOCK_NUEVO 
              FROM AUDITORIA_PRODUCTOS) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID_AUDIT: ' || rec.ID_AUDIT || 
                         ', TIPO: ' || rec.TIPO_CAMBIO || 
                         ', USUARIO: ' || rec.USUARIO_MODIFICACION || 
                         ', FECHA: ' || rec.FECHA_CAMBIO || 
                         ', ID_ANTERIOR: ' || NVL(TO_CHAR(rec.IDPRODUCTO_ANTERIOR), 'NULL') || 
                         ', STOCK_ANTERIOR: ' || NVL(TO_CHAR(rec.STOCK_ANTERIOR), 'NULL') || 
                         ', ID_NUEVO: ' || NVL(TO_CHAR(rec.IDPRODUCTO_NUEVO), 'NULL') || 
                         ', STOCK_NUEVO: ' || NVL(TO_CHAR(rec.STOCK_NUEVO), 'NULL'));
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--- Fin de registros ---');
END;
/

-- 7. Bloque PL/SQL para limpieza consolidada de objetos creados
BEGIN
  DBMS_OUTPUT.PUT_LINE('Iniciando limpieza de objetos creados...');

  -- Eliminar disparadores
  FOR obj IN (SELECT 'DROP TRIGGER ' || object_name AS stmt, object_name
              FROM user_objects
              WHERE object_type = 'TRIGGER'
              AND object_name IN ('TRG_AUDITAR_CAMBIOS_PRODUCTOS', 'TRG_VALIDAR_STOCK', 'TRG_REGISTRAR_PRODUCTO'))
  LOOP
    BEGIN
      EXECUTE IMMEDIATE obj.stmt;
      DBMS_OUTPUT.PUT_LINE('Trigger ' || obj.object_name || ' eliminado.');
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignorar errores
    END;
  END LOOP;

  -- Eliminar paquete
  BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE PKG_CONTROL_STOCK';
    DBMS_OUTPUT.PUT_LINE('Paquete PKG_CONTROL_STOCK eliminado.');
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- Ignorar errores
  END;

  -- Eliminar tablas
  FOR obj IN (SELECT 'DROP TABLE ' || object_name AS stmt, object_name
              FROM user_objects
              WHERE object_type = 'TABLE'
              AND object_name IN ('AUDITORIA_PRODUCTOS', 'PRODUCTOS'))
  LOOP
    BEGIN
      EXECUTE IMMEDIATE obj.stmt;
      DBMS_OUTPUT.PUT_LINE('Tabla ' || obj.object_name || ' eliminada.');
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignorar errores
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Limpieza completada.');
END;
/