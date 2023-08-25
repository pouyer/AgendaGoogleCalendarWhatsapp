CREATE OR REPLACE FUNCTION insertar_datos_desde_json()
RETURNS VOID AS
$$
DECLARE
    json_data JSONB;
    item_data JSONB;
    item_id VARCHAR;
    item_summary VARCHAR;
    item_description TEXT;
    item_start_date TIMESTAMP;
    attendee_email TEXT;
    attendee_organizer BOOLEAN;
    attendee_self BOOLEAN;
    attendee_response_status TEXT;
    description_data TEXT[];
BEGIN
    -- Supongamos que obtienes el JSON desde una tabla llamada tabla_cargue
    SELECT campojson INTO json_data FROM tabla_cargue WHERE id = 1;

    FOR item_data IN SELECT jsonb_array_elements(json_data->'items') AS item
    LOOP
        item_id := item_data->>'id';
        item_summary := item_data->>'summary';
        item_description := item_data->>'description';
        item_start_date := (item_data->'start')->>'dateTime';

        -- Supongamos que tienes una tabla llamada tabla_destino con columnas id, summary, description y start_date
        INSERT INTO tabla_destino (id, summary, description, start_date)
        VALUES (item_id, item_summary, item_description, item_start_date);

        -- Extraer información del campo 'description' y dividir los datos
        description_data := string_to_array(item_description, E'\n');

        -- Supongamos que tienes una tabla llamada tabla_description con columnas id_item, description_line
        FOR i IN 1..array_length(description_data, 1)
        LOOP
            INSERT INTO tabla_description (id_item, description_line)
            VALUES (item_id, description_data[i]);
        END LOOP;

        -- Extraer registros del campo 'attendees'
        FOR attendee IN SELECT * FROM jsonb_array_elements(item_data->'attendees')
        LOOP
            attendee_email := attendee->>'email';
            attendee_organizer := (attendee->>'organizer')::BOOLEAN;
            attendee_self := (attendee->>'self')::BOOLEAN;
            attendee_response_status := attendee->>'responseStatus';

            -- Supongamos que tienes una tabla llamada tabla_attendees con columnas email, organizer, self y response_status
            INSERT INTO tabla_attendees (email, organizer, self, response_status)
            VALUES (attendee_email, attendee_organizer, attendee_self, attendee_response_status);
        END LOOP;
    END LOOP;
END;
$$
LANGUAGE plpgsql;