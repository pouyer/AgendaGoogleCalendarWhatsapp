CREATE SEQUENCE IF NOT EXISTS public.s_agenda_google_pk
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 99999999999999999
    CACHE 1;

ALTER SEQUENCE public.s_agenda_google_pk
    OWNER TO adminangel;

GRANT ALL ON SEQUENCE public.s_agenda_google_pk TO PUBLIC;

GRANT ALL ON SEQUENCE public.s_agenda_google_pk TO adminangel WITH GRANT OPTION;


CREATE TABLE IF NOT EXISTS public.agenda_google
(
	secuencia bigint NOT NULL DEFAULT nextval('s_agenda_google_pk'::regclass),
	item jsonb,
	id text COLLATE pg_catalog."default",
	summary text COLLATE pg_catalog."default",
    start_date text COLLATE pg_catalog."default",
	start_date_fecha date,
	start_date_hora time,
    end_date text COLLATE pg_catalog."default",
	end_date_fecha date,
	end_date_Time time,
	status text COLLATE pg_catalog."default",
	htmlLink text COLLATE pg_catalog."default",
	attendees_organizer_mail text COLLATE pg_catalog."default",
	attendees_organizer_Status text COLLATE pg_catalog."default",
	attendees_mail text COLLATE pg_catalog."default",
	attendees_Status text COLLATE pg_catalog."default",
	description_nombre text COLLATE pg_catalog."default",
	description_telefono text COLLATE pg_catalog."default",
	mail_enviado boolean,
	mail_response jsonb,
	aud_fch_ins timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT agenda_google_pk PRIMARY KEY (secuencia)
        USING INDEX TABLESPACE "ts_angelData"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agenda_google
    OWNER to adminangel;

GRANT ALL ON TABLE public.agenda_google TO adminangel WITH GRANT OPTION;


SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'agenda_google');
