-- delete from carge_temporal;
-- delete from agenda_google;

select * from carge_temporal;
select * from agenda_google order by start_date;
--delete from descargajson;
select * from descargajson;
--delete from registro;
select * from registro;

select * from agenda_google order by start_date;
--delete from agenda_google;
--commit;
update agenda_google
  set mail_enviado = false
 where secuencia = 16;
  
select --* 
'57'||description_telefono as telefono,
'Buenas '|| F_DIAS_TARDES_NOCHEs(now()::timestamp::time)||
'.\n Le escribo para confirmar la cita de ' ||
description_nombre || ' programada para el dia '||start_date_fecha||' a las ['||start_date_hora||
'] con la doctora Claudia Forero.\n\nRecuerde que será en la nueva direccion: Autopista Norte # 118-86 consultorio 103.\n\nEnvío la encuesta para que por favor la diligencie antes de la consulta.\n\nPor favor confirmar asistencia para poder dar oportunidad a otro paciente, en caso de no poder asistir.\n\nPara cancelar la cita ingrese al link: '||htmllink as mensaje
from agenda_google 
where mail_enviado = false
and start_date_fecha = (:fecha::timestamp::date)
order by start_date;


  SELECT * -- campojson --INTO json_data 
  FROM carge_temporal WHERE estado = 'A';
  
  SELECT F_DIAS_TARDES_NOCHEs(now()::timestamp::time);
  select now();
  select now()::timestamp::time;
  
--  update carge_temporal
--     set estado = 'E'
--  where secuencia = 16;   

Buenas días.\n Le escribo para confirmar la cita de Pouyer Mejia programada para el dia 2023-07-24 a las [16:00:00] con la doctora Claudia Forero.\n\nRecuerde que será en la nueva direccion: Autopista Norte # 118-86 consultorio 103.\n\nEnvío la encuesta para que por favor la diligencie antes de la consulta.\n\nPor favor confirmar asistencia para poder dar oportunidad a otro paciente, en caso de no poder asistir.\n\nPara cancelar la cita ingrese al link: https://www.google.com/calendar/event?eid=dmswc2JnaXBwbDlkN2k0OWU4M3BhM3JkYzggY29uc3VsdG9yaW9jZm9yZXJvQG0

{"id": "voc150ipcsqs1hhq7vvfv3va0k", "end": {"dateTime": "2023-07-24T15:20:00-05:00", "timeZone": "America/Bogota"}, "etag": "\"3380071678388000\"", "kind": "calendar#event", "start": {"dateTime": "2023-07-24T15:00:00-05:00", "timeZone": "America/Bogota"}, "status": "confirmed", "colorId": "7", "created": "2023-07-22T14:23:59.000Z", "creator": {"self": true, "email": "consultoriocforero@gmail.com"}, "iCalUID": "voc150ipcsqs1hhq7vvfv3va0k@google.com", "summary": "Agenda Consultorio Claudia Forero (Carlos Mejia)", "updated": "2023-07-22T14:23:59.194Z", "htmlLink": "https://www.google.com/calendar/event?eid=dm9jMTUwaXBjc3FzMWhocTd2dmZ2M3ZhMGsgY29uc3VsdG9yaW9jZm9yZXJvQG0", "location": "Autopista Norte #118-86 Cons 103", "sequence": 0, "attendees": [{"email": "carloseduardomejia@gmail.com", "responseStatus": "accepted"}, {"self": true, "email": "consultoriocforero@gmail.com", "organizer": true, "responseStatus": "accepted"}], "eventType": "default", "organizer": {"self": true, "email": "consultoriocforero@gmail.com"}, "reminders": {"useDefault": true}, "description": "<b>Programada por</b>\nCarlos Mejia\ncarloseduardomejia@gmail.com\n3158991134\n<br><b>Observación</b>\nHola\n<br>Consulta de Ortodoncia", "extendedProperties": {"shared": {"goo.createdBySet": "default_cita", "goo.createdByAvailId": "7hu18pv8ffa48qf8s516f0mrrf"}}, "guestsCanInviteOthers": false}     

--------------------------
DO
$$
DECLARE
    my_text_variable TEXT := 'abc123def456xyz789';
    numeric_only TEXT;
BEGIN
    numeric_only := regexp_replace(my_text_variable, '[^0-9]', '', 'g');
    RAISE NOTICE 'Texto original: %', my_text_variable;
    RAISE NOTICE 'Texto con caracteres no numéricos eliminados: %', numeric_only;
END;
$$
LANGUAGE plpgsql;
/


SELECT
id as id,
'57' || description_telefono AS telefono,
'Buenas ' || f_dias_tardes_noches(now()::timestamp::time)|| '.\n'
|| ' Le escribo para confirmar la cita de '
|| description_nombre
|| ' programada para el dia '
|| start_date_fecha
|| ' a las '
|| start_date_hora
|| ' con la doctora Claudia Forero.\n\n'
|| 'Recuerde que será en la nueva direccion: Autopista Norte # 118-86 consultorio 103.\n\n'
|| 'Por favor confirmar asistencia para poder dar oportunidad a otro paciente, en caso de no poder asistir.\n\n'
|| 'Para cancelar la cita ingrese al link: \n'
|| htmllink
|| '\n\n'
|| 'Envío la encuesta para que por favor la diligencie antes de la consulta.\n\n'
AS mensaje from agenda_google where mail_enviado = false and start_date_fecha = '2023-07-24' 
order by start_date
;