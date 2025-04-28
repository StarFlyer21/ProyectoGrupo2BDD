DECLARE
  TYPE t_limited_rooms IS VARRAY(5) OF rooms.room_id%TYPE;
  v_top_rooms t_limited_rooms := t_limited_rooms(20000, 20001);
BEGIN
  -- Intentar añadir una tercera aula
  IF v_top_rooms.COUNT < 5 THEN
    v_top_rooms.EXTEND;
    v_top_rooms(3) := 20002;
  END IF;
END;