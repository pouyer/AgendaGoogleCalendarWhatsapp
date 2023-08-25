-- SEQUENCE: public.s_agenda_google_pk

-- DROP SEQUENCE IF EXISTS public.s_agenda_google_pk;

CREATE SEQUENCE IF NOT EXISTS public.s_agenda_google_pk
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 99999999999999999
    CACHE 1;

ALTER SEQUENCE public.s_agenda_google_pk
    OWNER TO adminagenda;

GRANT ALL ON SEQUENCE public.s_agenda_google_pk TO PUBLIC;

GRANT ALL ON SEQUENCE public.s_agenda_google_pk TO adminagenda WITH GRANT OPTION;


-- DROP TABLE IF EXISTS public.agenda_google;

CREATE TABLE IF NOT EXISTS public.agenda_google
(
    secuencia bigint NOT NULL DEFAULT nextval('s_agenda_google_pk'::regclass),
    idarchivo character varying(128) COLLATE pg_catalog."default",
    item jsonb,
    id text COLLATE pg_catalog."default",
    summary text COLLATE pg_catalog."default",
    start_date text COLLATE pg_catalog."default",
    start_date_fecha date,
    start_date_hora character varying(128) COLLATE pg_catalog."default",
    end_date text COLLATE pg_catalog."default",
    end_date_fecha date,
    end_date_hora character varying(128) COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    htmllink text COLLATE pg_catalog."default",
    attendees_organizer_mail text COLLATE pg_catalog."default",
    attendees_organizer_status text COLLATE pg_catalog."default",
    attendees_mail text COLLATE pg_catalog."default",
    attendees_status text COLLATE pg_catalog."default",
    description_nombre text COLLATE pg_catalog."default",
    description_telefono text COLLATE pg_catalog."default",
    mail_enviado boolean,
    mail_response jsonb,
	id_usuario character varying(128),
    mensaje_enviado text,
	fecha_envio timestamp with time zone,
    aud_fch_ins timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT agenda_google_pk PRIMARY KEY (secuencia)
        USING INDEX TABLESPACE "TS_agendaData",
	CONSTRAINT idx_id_item UNIQUE (id)
        USING INDEX TABLESPACE "TS_agendaData",
	CONSTRAINT fk_agendaGoogle_DatosUsuario FOREIGN KEY (id_usuario)
        REFERENCES public.datos_usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID	
		
)

TABLESPACE "TS_agendaData";

ALTER TABLE IF EXISTS public.agenda_google
    OWNER to adminagenda;

GRANT ALL ON TABLE public.agenda_google TO adminagenda WITH GRANT OPTION;

COMMENT ON CONSTRAINT idx_id_item ON public.agenda_google
    IS 'indice unico para el campo ID donde queda el identificador unico del evento del calendario';
	
ALTER TABLE agenda_google ADD COLUMN id_usuario character varying(128) COLLATE pg_catalog."default";
ALTER TABLE agenda_google ADD COLUMN Mensaje_enviado text;




--------------------------------
-- SEQUENCE: public.s_cargue_temporal

-- DROP SEQUENCE IF EXISTS public.s_cargue_temporal;

CREATE SEQUENCE IF NOT EXISTS public.s_cargue_temporal
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
    --OWNED BY carge_temporal.secuencia;

ALTER SEQUENCE public.s_cargue_temporal
    OWNER TO adminagenda;

GRANT ALL ON SEQUENCE public.s_cargue_temporal TO PUBLIC;

GRANT ALL ON SEQUENCE public.s_cargue_temporal TO adminagenda WITH GRANT OPTION;

------------------------------
-- DROP TABLE IF EXISTS public.carge_temporal;

CREATE TABLE IF NOT EXISTS public.carge_temporal
(
    secuencia bigint NOT NULL DEFAULT nextval('s_cargue_temporal'::regclass),
    campojson jsonb,
    nombrearchivo character varying(128) COLLATE pg_catalog."default",
    estado "char" DEFAULT 'A'::"char",
	id_usuario character varying(128) COLLATE pg_catalog."default",
	aud_fch_ins timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    aud_usu_ins character varying(128) COLLATE pg_catalog."default",
    CONSTRAINT prueba_pkey PRIMARY KEY (secuencia)
        USING INDEX TABLESPACE "TS_agendaData",
    CONSTRAINT idx_nombrearchivo UNIQUE (nombrearchivo)
        USING INDEX TABLESPACE "TS_agendaData",
	CONSTRAINT fk_pru_usuario FOREIGN KEY (id_user)
        REFERENCES public.datos_usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID	
)

TABLESPACE "TS_agendaData";

---
id_usuario character varying(128) COLLATE pg_catalog."default"
 id_user character varying(128) NOT NULL,

    CONSTRAINT fk_pru_usuario FOREIGN KEY (id_user)
        REFERENCES public.datos_usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
---
ALTER TABLE IF EXISTS public.carge_temporal
    OWNER to adminagenda;

GRANT ALL ON TABLE public.carge_temporal TO adminagenda WITH GRANT OPTION;

COMMENT ON CONSTRAINT idx_nombrearchivo ON public.carge_temporal
    IS 'indice unico para el id que genera cargue o nombre del archivo a cargar';

ALTER TABLE carge_temporal RENAME COLUMN aud_usu_ins TO id_usuario;

--------------------------------
-- SEQUENCE: public.s_Datos_usuario

-- DROP SEQUENCE IF EXISTS public.s_Datos_usuario;

CREATE SEQUENCE IF NOT EXISTS public.s_Datos_usuario
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;


ALTER SEQUENCE public.s_Datos_usuario
    OWNER TO adminagenda;

GRANT ALL ON SEQUENCE public.s_Datos_usuario TO PUBLIC;

GRANT ALL ON SEQUENCE public.s_Datos_usuario TO adminagenda WITH GRANT OPTION;
----------------------------
-- DROP TABLE IF EXISTS public.Datos_usuario;

CREATE TABLE IF NOT EXISTS public.Datos_usuario
(

    id_usuario character varying(128) NOT NULL COLLATE pg_catalog."default",
    nombreUsuario character varying(128) NOT NULL COLLATE pg_catalog."default",
	nombreConsultorio character varying(128) COLLATE pg_catalog."default",
	direccion character varying(128) COLLATE pg_catalog."default",
	telefono character varying(128) COLLATE pg_catalog."default",
	telefono2 character varying(128) COLLATE pg_catalog."default",
	emailGoogle character varying(128) COLLATE pg_catalog."default",
	claveGoogle character varying(128) COLLATE pg_catalog."default",
	diasconsulta int NOT NULL DEFAULT 0 ,
	UrlApiGoogle character varying(128) COLLATE pg_catalog."default",
	UrlApiWhatsapp character varying(128) COLLATE pg_catalog."default",
    estado "char" DEFAULT 'A'::"char",
	aud_fch_ins timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    aud_usu_ins character varying(128) COLLATE pg_catalog."default",
    CONSTRAINT Datos_usuario_pk PRIMARY KEY (id_usuario)
        USING INDEX TABLESPACE "TS_agendaData",

)

TABLESPACE "TS_agendaData";

ALTER TABLE IF EXISTS public.Datos_usuario
    OWNER to adminagenda;

GRANT ALL ON TABLE public.Datos_usuario TO adminagenda WITH GRANT OPTION;

COMMENT ON CONSTRAINT idx_idusuario ON public.Datos_usuario
    IS 'indice unico para el id de cada usuario';