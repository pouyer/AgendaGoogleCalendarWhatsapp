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
    
    v_item_start_date TIMESTAMP;
	v_start_date_fecha date;
    v_start_date_hora VARCHAR;
            
    v_item_end_date TIMESTAMP;
	v_end_date_fecha date;
    v_end_date_hora VARCHAR;
        
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
	INSERT INTO carge_temporal( campojson, nombrearchivo, id_usuario) VALUES (datojson, p_idarchivo, usuario);
    -- Supongamos que obtienes el JSON desde una tabla llamada tabla_cargue
	--SELECT campojson INTO json_data FROM carge_temporal WHERE estado = 'A';

    --FOR v_item IN SELECT jsonb_array_elements(json_data->'items') AS item
	FOR v_item IN SELECT jsonb_array_elements(datojson->'items') AS item
    LOOP
        v_id := v_item->>'id';
        v_summary := v_item->>'summary';

		v_item_start_date := (v_item->'start')->>'dateTime';
		select v_item_start_date::timestamp::date into v_start_date_fecha;
		--select v_item_start_date::timestamp::time into v_start_date_hora;
		SELECT TO_CHAR(v_item_start_date::timestamp::time, 'HH:MI AM') into v_start_date_hora;

		v_item_end_date := (v_item->'end')->>'dateTime';
		select v_item_end_date::timestamp::date into v_end_date_fecha;
		--select v_item_end_date::timestamp::time into v_end_date_hora;
		SELECT TO_CHAR(v_item_end_date::timestamp::time, 'HH:MI AM') into v_end_date_hora;
       
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
	IF f_existe_registro('agenda_google',v_id) THEN
		RAISE NOTICE 'El registro con id % existe en la tabla.', v_id;
	ELSE
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
											end_date_hora,
											status,
											htmllink,
											attendees_organizer_mail,
											attendees_organizer_status,
											attendees_mail,
											attendees_status,
											description_nombre,
											description_telefono,
											mail_enviado,
											mail_response,
											id_usuario	) 
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
												v_end_date_hora,
												v_status,
												v_htmllink,
												v_attendees_organizer_mail,
												v_attendees_organizer_status,
												v_attendee_mail,
												v_attendee_status,
												v_description_nombre,
												f_dejarNumeros(v_description_telefono),
												'N',
												NULL,
												usuario
											);
	END IF;
        -- Commitear al final de cada iteración (transacción por lote)
    END LOOP;
END;
$BODY$;

GRANT EXECUTE ON PROCEDURE public.sp_insertar_json_agenda(jsonb, text, text) TO adminagenda WITH GRANT OPTION;

GRANT EXECUTE ON PROCEDURE public.sp_insertar_json_agenda(jsonb, text, text) TO adminagenda;

GRANT EXECUTE ON PROCEDURE public.sp_insertar_json_agenda(jsonb, text, text) TO PUBLIC;

---------------------------------------------
-- PROCEDURE: public.sp_actualiza_datos_agenda(text, jsonb)

 --DROP PROCEDURE IF EXISTS public.sp_actualiza_datos_agenda(text, jsonb,text);

CREATE OR REPLACE PROCEDURE public.sp_actualiza_datos_agenda(
	IN llave text,
	IN mail_respuesta jsonb,
	IN p_mensaje_enviado text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	--actualiza los indicadores que los datos ya fueron copiados a la base de datos
	UPDATE public.agenda_google
	  SET  	"mail_enviado" 	= true,
	  		"mail_response"	= mail_respuesta,
			"fecha_envio" = now(),
			"mensaje_enviado" = p_mensaje_enviado
	where "id" = llave
	and "mail_enviado" = false;
END;
$BODY$;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb,text) TO adminagenda WITH GRANT OPTION;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb,text) TO adminagenda;

GRANT EXECUTE ON PROCEDURE public.sp_actualiza_datos_agenda(text, jsonb,text) TO PUBLIC;


--SELECT TO_CHAR('16:40', 'HH:MI AM');
