--INSERT INTO public.datos_usuario(
--	id_usuario, nombreusuario, nombreconsultorio, direccion, telefono, telefono2, emailgoogle, clavegoogle, diasconsulta, urlapigoogle, urlapiwhatsapp, estado, aud_usu_ins)
--	VALUES ( 'ClaudiaForero', 'Claudia Forero', 'Norte', 'Autopista Norte #118-86 consultorio 103', '3028600503', null, 'consultoriocforero@gmail.com', 'Claudia123/', 1, 'http://localhost:8000/calendar/list/', 'http://localhost:3001/lead', 'A',  'Carlos Mejia');

SELECT * FROM public.datos_usuario;

SELECT * FROM public.carge_temporal order by aud_fch_ins desc;

SELECT * FROM public.agenda_google 
--where --idarchivo = 'nomArc_2023-07-27_192304' 
--id ='vk0sbgippl9d7i49e83pa3rdc8'
ORDER BY 2,1;


--delete  FROM public.agenda_google 
--where idarchivo = 'nomArc_2023-07-27_192304' ;