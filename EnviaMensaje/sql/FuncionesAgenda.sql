-- FUNCTION: public.f_dejarnumeros(text)

-- DROP FUNCTION IF EXISTS public.f_dejarnumeros(text);

CREATE OR REPLACE FUNCTION public.f_dejarnumeros(
	p_telefono text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	return regexp_replace(p_telefono, '[^0-9]', '', 'g');
END;
$BODY$;

ALTER FUNCTION public.f_dejarnumeros(text)
    OWNER TO agendacf;

GRANT EXECUTE ON FUNCTION public.f_dejarnumeros(text) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.f_dejarnumeros(text) TO agendacf WITH GRANT OPTION;

---------------------
-- DROP FUNCTION IF EXISTS public.f_dias_tardes_noches(time without time zone);

CREATE OR REPLACE FUNCTION public.f_dias_tardes_noches(
	p_hora time without time zone)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	
	IF p_hora >= '04:00' AND p_hora < '12:00' THEN
	   return 'Buenos días';
	ELSE IF  p_hora >= '12:00' AND p_hora < '19:00' THEN 
			return 'Buenas tardes';
		 ELSE
		 	return 'Buenas noches';
		 END IF;
	END IF;	 
	
END;
$BODY$;

ALTER FUNCTION public.f_dias_tardes_noches(time without time zone)
    OWNER TO agendacf;

GRANT EXECUTE ON FUNCTION public.f_dias_tardes_noches(time without time zone) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.f_dias_tardes_noches(time without time zone) TO agendacf WITH GRANT OPTION;

--------------------------------------------------
-- DROP FUNCTION IF EXISTS public.f_existe_registro(text,text);

CREATE OR REPLACE FUNCTION f_existe_registro(p_tabla_name TEXT, p_id_registro TEXT)
RETURNS BOOLEAN AS
$$
DECLARE
    v_registro_existente BOOLEAN;
BEGIN
    EXECUTE format('SELECT EXISTS (SELECT 1 FROM %I WHERE id = $1)', p_tabla_name)
    INTO v_registro_existente
    USING p_id_registro;
    
    RETURN v_registro_existente;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$
LANGUAGE plpgsql;


ALTER FUNCTION public.f_existe_registro(text,text)
    OWNER TO agendacf;

GRANT EXECUTE ON FUNCTION public.f_existe_registro(text,text) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.f_existe_registro(text,text) TO agendacf WITH GRANT OPTION;


