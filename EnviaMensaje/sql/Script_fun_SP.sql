--drop FUNCTION public.f_dias_tardes_noche;
CREATE OR REPLACE FUNCTION public.f_dias_tardes_noches(p_hora time)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	
	IF p_hora >= '04:00' AND p_hora < '12:00' THEN
	   return 'días';
	ELSE IF  p_hora >= '12:00' AND p_hora < '19:00' THEN 
			return 'tardes';
		 ELSE
		 	return 'noches';
		 END IF;
	END IF;	 
	
END;
$BODY$;

ALTER FUNCTION public.f_dias_tardes_noches(time)
    OWNER TO adminangel;

GRANT EXECUTE ON FUNCTION public.f_dias_tardes_noches(time) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.f_dias_tardes_noches(time) TO adminangel WITH GRANT OPTION;

--------------------------------------------------------------------------------------------
-- PROCEDURE: public.sp_actualiza_datos_agenda(text, jsonb)

-- DROP PROCEDURE IF EXISTS public.sp_actualiza_datos_agenda(text, jsonb);

CREATE OR REPLACE PROCEDURE public.sp_actualiza_datos_agenda(
	IN llave text,
	IN mail_respuesta jsonb)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	--actualiza los indicadores que los datos ya fueron copiados a la base de datos
	UPDATE public.agenda_google
	  SET  	"mail_enviado" 	= true,
	  		"mail_response"	= mail_respuesta,
			"fecha_envio" = now()
	where "id" = llave
	and "mail_enviado" = false;
END;
$BODY$;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb) TO adminangel WITH GRANT OPTION;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb) TO postgres;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb) TO PUBLIC;

-----------------------------------------------------------------------------------------------------------------
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
    OWNER TO adminangel;

GRANT EXECUTE ON FUNCTION public.f_dejarnumeros(text) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.f_dejarnumeros(text) TO adminangel WITH GRANT OPTION;

------------------------------------------------------------------------------------------------------------------
-- PROCEDURE: public.sp_insertar_json_agenda(jsonb, text, text)

-- DROP PROCEDURE IF EXISTS public.sp_insertar_json_agenda(jsonb, text, text);

CREATE OR REPLACE PROCEDURE public.sp_insertar_json_agenda(
	IN datojson jsonb,
	IN p_idarchivo text,
	IN usuario text)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    json_data jsonb;
    v_item jsonb;
    v_id VARCHAR;
    v_summary VARCHAR;
    
    v_start_date_fecha date;
    v_start_date_hora time;
    v_item_start_date TIMESTAMP;
        
    v_end_date_fecha date;
    v_end_date_time time;
    v_item_end_date TIMESTAMP;
    
    v_status TEXT;
    v_htmlLink text;
    
    v_attendees_organizer_mail text ;
    v_attendees_organizer_status text ;
    v_attendee_mail text;
    v_attendee_status text;
    v_attendee_organizer BOOLEAN; 
    v_attendee  jsonb;
    
    v_description_nombre text ;
    v_description_mail text ;
    v_description_telefono text;
    item_description TEXT;
    v_description_data TEXT[];
    
    v_mail_enviado BOOLEAN;
    v_mail_response jsonb;
BEGIN
     -- INSERTA EN TABLA TEMPORAL
	INSERT INTO carge_temporal( campojson, nombrearchivo, aud_usu_ins) VALUES (datojson, p_idarchivo, usuario);
    -- Supongamos que obtienes el JSON desde una tabla llamada tabla_cargue
	--SELECT campojson INTO json_data FROM carge_temporal WHERE estado = 'A';

    --FOR v_item IN SELECT jsonb_array_elements(json_data->'items') AS item
	FOR v_item IN SELECT jsonb_array_elements(datojson->'items') AS item
    LOOP
        v_id := v_item->>'id';
        v_summary := v_item->>'summary';

		v_item_start_date := (v_item->'start')->>'dateTime';
		select v_item_start_date::timestamp::date into v_start_date_fecha;
		select v_item_start_date::timestamp::time into v_start_date_hora;

		v_item_end_date := (v_item->'end')->>'dateTime';
		select v_item_end_date::timestamp::date into v_end_date_fecha;
		select v_item_end_date::timestamp::time into v_end_date_time;
       
        v_status := v_item->>'status';
        v_htmlLink := v_item->>'htmlLink';
        item_description := v_item->>'description';
        
        -- Extraer información del campo 'description' y dividir los datos
        v_description_data := string_to_array(item_description, E'\n');
		-- limpia las variables para que inicien sin datos
		v_description_nombre := null;
        v_description_mail := null;
		v_description_telefono := null;
        IF array_length(v_description_data, 1) >= 3 THEN
            v_description_nombre := v_description_data[2];
            v_description_mail := v_description_data[3];
        END IF;
        IF array_length(v_description_data, 1) >= 4 THEN
            v_description_telefono := v_description_data[4];
			
        END IF;

        -- Extraer registros del campo 'attendees'
        FOR v_attendee IN SELECT * FROM jsonb_array_elements(v_item->'attendees')
        LOOP
            v_attendee_organizer := (v_attendee->>'organizer')::BOOLEAN;
            IF v_attendee_organizer THEN
                v_attendees_organizer_mail := v_attendee->>'email';
                v_attendees_organizer_status := v_attendee->>'responseStatus';
            ELSE
                v_attendee_mail := v_attendee->>'email';
                v_attendee_status := v_attendee->>'responseStatus';
            END IF;
        END LOOP;

    INSERT INTO public.agenda_google (
										item,
										idarchivo,
										id,
										summary,
										start_date,
										start_date_fecha,
										start_date_hora,
										end_date,
										end_date_fecha,
										end_date_time,
										status,
										htmllink,
										attendees_organizer_mail,
										attendees_organizer_status,
										attendees_mail,
										attendees_status,
										description_nombre,
										description_telefono,
										mail_enviado,
										mail_response) 
								VALUES (
											v_item,
											p_idarchivo,
											v_id,
											v_summary,
											v_item_start_date,
											v_start_date_fecha,
											v_start_date_hora,
											v_item_end_date,
											v_end_date_fecha,
											v_end_date_time,
											v_status,
											v_htmllink,
											v_attendees_organizer_mail,
											v_attendees_organizer_status,
											v_attendee_mail,
											v_attendee_status,
											v_description_nombre,
											f_dejarNumeros(v_description_telefono),
											'N',
											NULL
										);
        -- Commitear al final de cada iteración (transacción por lote)
    END LOOP;
END;
$BODY$;

