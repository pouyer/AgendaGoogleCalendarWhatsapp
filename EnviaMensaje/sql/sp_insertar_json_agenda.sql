CREATE OR REPLACE PROCEDURE sp_insertar_json_agenda(IN datojson JSONB, IN IDarchivo text, IN usuario text)
AS
$$
DECLARE
    json_data JSONB;
    v_item JSONB;
    v_id VARCHAR;
    v_summary VARCHAR;
    
    v_start_date_fecha date;
    v_start_date_hora time;
    v_item_start_date TIMESTAMP;
    v_item_start_date_text TEXT;
        
    v_end_date_fecha date;
    v_end_date_Time time;
    v_item_end_date TIMESTAMP;
    v_item_end_date_text TEXT;
    
    v_status TEXT;
    v_htmlLink text;
    
    v_attendees_organizer_mail text ;
    v_attendees_organizer_Status text ;
    v_attendee_email text;
    v_attendee_response_status text;
    v_attendee_organizer BOOLEAN; 
    v_attendee  JSONB;
    
    v_description_nombre text ;
    v_description_mail text ;
    v_description_telefono text;
    item_description TEXT;
    v_description_data TEXT[];
    
    v_mail_enviado BOOLEAN;
    v_mail_response JSONB;
BEGIN
    -- INSERTA EN TABLA TEMPORAL
	INSERT INTO carge_temporal( campojson, nombrearchivo, aud_usu_ins) VALUES (datojson, IDarchivo, usuario);
    -- Supongamos que obtienes el JSON desde una tabla llamada tabla_cargue
    SELECT campojson INTO json_data FROM carge_temporal WHERE estado = 'A';

    FOR v_item IN SELECT jsonb_array_elements(json_data->'items') AS item
    LOOP
        v_id := v_item->>'id';
        v_summary := v_item->>'summary';
        
        v_item_start_date_text := (v_item->'start')->>'dateTime';
        --v_start_date_fecha := date(v_item_start_date);
        --v_start_date_hora := time(v_item_start_date);
       
        v_item_end_date_text := (v_item->'end')->>'dateTime';
        --v_end_date_fecha := date(v_item_end_date);
        --v_end_date_Time := time(v_item_end_date);
        
        -- Convertir las fechas y horas al tipo de dato TIMESTAMP
       -- v_item_start_date := to_timestamp(v_item_start_date_text, 'YYYY-MM-DD"T"HH24:MI:SSOF');
       -- v_item_end_date := to_timestamp(v_item_end_date_text, 'YYYY-MM-DD"T"HH24:MI:SSOF');

       
        v_status := v_item->>'status';
        v_htmlLink := v_item->>'htmlLink';
        item_description := v_item->>'description';
        
        -- Extraer información del campo 'description' y dividir los datos
        v_description_data := string_to_array(item_description, E'\n');

        -- Supongamos que tienes una tabla llamada tabla_description con columnas id_item, description_line
        FOR i IN 1..array_length(v_description_data, 1)
        LOOP
            IF i = 2 THEN
                v_description_nombre = description_data[i];
            END IF;
             IF i = 3 THEN
                v_description_mail = description_data[i];
            END IF;
             IF i = 4 THEN
                v_description_telefono = description_data[i];
            END IF;
            VALUES (item_id, description_data[i]);
        END LOOP;

        -- Extraer registros del campo 'attendees'
        FOR v_attendee IN SELECT * FROM jsonb_array_elements(v_item->'attendees')
        LOOP
            v_attendee_organizer := (v_attendee->>'organizer')::BOOLEAN;
            IF v_attendee_organizer THEN
                v_attendees_organizer_mail := v_attendee->>'email';
                v_attendees_organizer_Status := v_attendee->>'responseStatus';
            ELSE
                v_attendee_email := v_attendee->>'email';
                v_attendee_response_status := v_attendee->>'responseStatus';
            END IF;
            
        END LOOP;

        INSERT INTO public.agenda_google (  item,
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
                                            mail_response
                                        ) VALUES (
                                            v_item,
                                            v_id,
                                            v_summary,
                                            v_item_start_date_text,
                                            NULL,
                                            NULL,
                                            v_item_end_date_text,
                                            NULL,
                                            NULL,
                                            v_status,
                                            v_htmllink,
                                            v_attendees_organizer_mail,
                                            v_attendees_organizer_status,
                                            v_attendees_mail,
                                            v_attendee_response_status,
                                            v_description_nombre,
                                            v_description_telefono,
                                            'N',
                                            NULL
                                        );
    END LOOP;
END;
$$
LANGUAGE plpgsql;
