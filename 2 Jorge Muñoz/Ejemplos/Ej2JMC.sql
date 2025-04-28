DECLARE
  TYPE t_course_list IS TABLE OF classes%ROWTYPE;
  v_courses t_course_list := t_course_list(); -- Constructor vacío
BEGIN
  -- Extender y cargar el primer curso
  v_courses.EXTEND;
  SELECT * INTO v_courses(1) 
  FROM classes WHERE department = 'CS' AND course = 101;
  
  -- Eliminar el último curso si no es necesario
  v_courses.TRIM;
END;