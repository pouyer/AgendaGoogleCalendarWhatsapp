select
	(campojson->idkey ->> 'items')::jsonb
	,idkey
	--, CURRENT_TIMESTAMP
	--, to_timestamp(campojson->idkey ->> 'upload_time', 'DDMMYYYYHH24MISS') as fechaCarga
	, campojson->idkey ->> 'summary' as summary
	--, usuario
	--, archivo
	from public.carge_temporal p
	join (select jsonb_object_keys (campojson) as idkey
		  , secuencia as secu
			FROM public.carge_temporal v1
		  ) v_idkey
		  on (v_idkey.secu = p.secuencia)
		where p.estado = 'C'	
			;
            
            select jsonb_object_keys (campojson) as idkey
		  , secuencia as secu
			FROM public.carge_temporal v1
            ;
            
-----------------------------------------------
SELECT 
	"IDReguistro" as IdKey,
	"idDispositivo" as IdDispositivo,
	t.doc ->> 'etag' 	as "id" 
--	CAST (t.doc ->> 'Vel' AS INTEGER) as "Vel",
--	CAST(t.doc ->> 'Ax' AS DECIMAL (5,2)) AS "Ax",
--	CAST(t.doc ->> 'Ay' AS DECIMAL (5,2)) AS "Ay" ,
--	CAST(t.doc ->> 'Az' AS DECIMAL (5,2)) AS "Az" ,	
--	CAST (t.doc ->> 'Dr' AS INTEGER) as "Dr" ,
--	CAST (t.doc ->> 'Dl' AS INTEGER) as "Dl" ,
--	CAST (t.doc ->> 'Dt' AS INTEGER) as "Dt" ,
--	CAST (t.doc ->> 'Ta' AS INTEGER) as "Ta" ,
--	t.doc ->> 'Ts' 	as "Ts" ,
--	CAST(t.doc ->> 'GPS_lat' AS DECIMAL (8,6)) AS "GPS_lat" ,
--	CAST(t.doc ->> 'GPS_lon' AS DECIMAL (8,6)) AS "GPS_lon" ,
--	t.doc ->> 'upload_time' as "fechaCargada"
	from public.descargajson, 
		 jsonb_array_elements(response) AS t(doc)
	where "insertoDBSql" = false	 
	;
    
    
    
SELECT 
ITEM,
ITEM->>'id' as id,
ITEM->>'summary' as summary,
--ITEM->>'start' as start,
(ITEM->'start')->>'dateTime' as start,
(ITEM->'end')->>'dateTime' as end,

ITEM->>'status' as status,
ITEM->>'htmlLink' as htmlLink,
ITEM->>'attendees' as attendees,
(ITEM->'attendees')->>'email' as attendeeseMail,

ITEM->>'description' as description,

--ITEM->>'htmlLink' as htmlLink
from carge_temporal,
    jsonb_array_elements(campojson->'items') as ITEM
;
    json_array_elements(campojson->'items') AS item;

SELECT * FROM jsonb_array_elements(v_item->'attendees')

-----
{"id": "icqjqduvn7q3s6m7e3pq5brmt0", 
"end": {"dateTime": "2023-07-24T14:20:00-05:00", "timeZone": "America/Bogota"}, "etag": "\"3379963155120000\"", "kind": "calendar#event", "start": {"dateTime": "2023-07-24T14:00:00-05:00", "timeZone": "America/Bogota"}, "status": "confirmed", "colorId": "7", "created": "2023-07-21T23:19:37.000Z", "creator": {"self": true, "email": "consultoriocforero@gmail.com"}, "iCalUID": "icqjqduvn7q3s6m7e3pq5brmt0@google.com", "summary": "Agenda Consultorio Claudia Forero (CLAUDIA VIVIAN FORERO MANRIQUE)", "updated": "2023-07-21T23:19:37.560Z", "htmlLink": "https://www.google.com/calendar/event?eid=aWNxanFkdXZuN3EzczZtN2UzcHE1YnJtdDAgY29uc3VsdG9yaW9jZm9yZXJvQG0", "sequence": 0, 
"attendees": [{"self": true, "email": "consultoriocforero@gmail.com", "organizer": true, "responseStatus": "accepted"}, {"email": "cv.forero@unicieo.edu.co", "responseStatus": "accepted"}],
"eventType": "default", "organizer": {"self": true, "email": "consultoriocforero@gmail.com"}, "reminders": {"useDefault": true}, 
"description": "<b>Programada por</b>\nCLAUDIA VIVIAN FORERO MANRIQUE\ncv.forero@unicieo.edu.co\n3158991133\n<br><b>identificacion</b>\n315346665", "extendedProperties": {"shared": {"goo.createdBySet": "default_cita", "goo.createdByAvailId": "7hu18pv8ffa48qf8s516f0mrrf"}}, "guestsCanInviteOthers": false}