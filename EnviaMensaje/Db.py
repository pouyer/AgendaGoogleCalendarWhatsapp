"""
    Conexión a PostgreSQL con Python
    Ejemplo de CRUD evitando inyecciones SQL
    @author CARLOS MEJIA
    15/12/2021

{
    "dbname": "desaangel",
    "user": "adminangel",
    "password": "adminangel",
    "host": "localhost",
    "port": 5432
}

{
    "dbname": "agendaconsultoriocforero",
    "user": "agendacf",
    "password": "agendacf",
    "host": "192.168.1.70",
    "port": 5432
}
"""
import psycopg2
import json
import log

def obtener_conexion():
    with open("./config/credencialesDB.json") as archivo_credenciales:
        credenciales = json.load(archivo_credenciales)
    try:
        conexion = psycopg2.connect(**credenciales)
        return conexion
    except psycopg2.Error as e:
        log.error(f"Db. Ocurrió un error al conectar a Base de Datos PostgreSQL: {e}")
        return None