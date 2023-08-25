-- Role: adminagenda
-- DROP ROLE IF EXISTS adminagenda;

CREATE ROLE adminagenda WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:goxKKLJZI9zZpwmXmHMzsA==$u53nADDJvSxwwHnezW0kC/61zpjo1biVS6+UfF2VkLI=:Hfw4VrflsywT5L5cEzbrr4buTTgOCpQoyvw0xfcu3KY=';

COMMENT ON ROLE adminagenda IS 'administrador de la base de Agendamiento';


--- Creacion de TABLESPACE
CREATE TABLESPACE "TS_agendaData"
  OWNER adminagenda
  LOCATION E'F:\\postgresTSAgenda';

ALTER TABLESPACE "TS_agendaData"
  OWNER TO adminagenda;

COMMENT ON TABLESPACE "TS_agendaData"
  IS 'almacenamiento de la data de la agendas leidas';
-----  
  CREATE TABLESPACE "TS_agendaIndex"
  OWNER adminagenda
  LOCATION E'F:\\postgresTSAgenda';

ALTER TABLESPACE "TS_agendaIndex"
  OWNER TO adminagenda;
-----------------------------------------------
  CREATE DATABASE agendamiento
    WITH
    OWNER = adminagenda
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    TABLESPACE = "TS_agendaData"
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE agendamiento
    IS 'Base de datos para almacenar los agendamientos de Google calendari y envio por whatsapp';