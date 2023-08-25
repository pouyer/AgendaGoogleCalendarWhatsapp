import configparser
import log
import datetime
import json
import requests
import psycopg2
from Db import conexion
from datetime import date, timedelta
import time
import EnvioMensaje as wsp
import demonio as dm


# Lee las variables de conexión y otras configuraciones desde el archivo de configuración
config = configparser.ConfigParser()
config.read('.\config\config.ini')


def fecha():
    # Obtener la fecha del día actual
    fecha_actual = date.today()
    # Obtener la fecha del día siguiente
    fecha_siguiente = fecha_actual + timedelta(days=1)
    # Verificar si el día siguiente es domingo
    if fecha_siguiente.weekday() == 6:  # El 6 representa el domingo (lunes es 0, martes es 1, y así sucesivamente)
        fecha_siguiente = fecha_actual + timedelta(days=2)  # Obtener el siguiente día si el día siguiente es domingo
    return fecha_siguiente

def LeeApi(url,fecha):
    url = url+str(fecha)  
    #url = url+'2023-07-24'  
    log.debug(f"LeeApi: {url}")  
    response = requests.get(url)
    if response.status_code == 200:
        #content = response.content
        content = response.json()
        return content
    else:
        content = response.status_code
    return content

    json_data = response.json()

def lee_sql_envia_msg(sql):
    try:
        with conexion.cursor() as cursor:
            #cursor.execute(sql, {'fecha': fecha})
            #cursor.execute(sql, (fecha,))
            cursor.execute(sql)
            #log.info("  Inicia proceso de depuracion API:")
            # Hacer un while, mientras fetchone no regrese None
            registros = cursor.fetchall()
            for telefono, mensaje in registros:
                log.debug(f"Registro Telefono: {telefono} mensaje: {mensaje} ")
                responseWsp = wsp.sendMessage(config['API']['UrlApiWapp'],telefono, mensaje)
                log.info(f"La respuesta del envio del mensaje es: {responseWsp}")
    except psycopg2.Error as e:
        log.error(f"2.0. Al enviar mensaje por whatsapp: {e}")
    finally:
        cursor.close()
        conexion.close()

def insertaDB(content,IDarchivo,sql):
    try:
        with conexion.cursor() as cursor:
            my_json = json.dumps(content,)
            insert_query = 'CALL sp_insertar_json_agenda(%s, %s,%s)'
            cursor.execute(insert_query, (my_json, IDarchivo,"DesdePythonASUS",))
            log.info(f" Se ejecuto insercion en Base de Datos con ID: {IDarchivo}")
            # empieza eliminacion
           # sql= query = config.get('QUERY', 'sql').strip().replace('\n', ' ')
           # update_query = 'CALL sp_actualizadescargajson(%s, %s)'
            try:
                cursor.execute(sql)
                # Hacer un while, mientras fetchone no regrese None
                registros = cursor.fetchall()
                for id, telefono, mensaje in registros:
                    data_json = None
                    if mensaje is not None:
                        mensaje = mensaje.strip().replace('||', '\n')
                    
                    if telefono is not None:
                        responseWsp = wsp.sendMessage(config['API']['UrlApiWapp'],telefono, mensaje)
                        #responseWsp = json.dumps(responseWsp,)
                        data_json = json.loads(responseWsp.content.decode('utf-8'))
                        data_json = json.dumps(data_json,)
                        log.info(f"Envio mensaje telefono {telefono} id de cita: {id} respuesta envio: {data_json}")
                    log.debug(f"Registro Telefono: {telefono} mensaje: {mensaje} ")
                    try:
                        update_query = 'CALL sp_actualiza_datos_agenda(%s, %s)'
                        cursor.execute(update_query, (id,data_json,))
                        log.debug(f"Actualiza agenda a enviada ID: {id}  ")
                    except psycopg2.Error as e:
                            log.error(f"4.0. Ocurrio un error al actualiza reguistro en base de datos:[{e}]")
            except psycopg2.Error as e:
                log.error(f"3.0. Ocurrio un error al enviar mensaje o actualiza reguistro de envio:[{e}]")
            conexion.commit()  # Si no haces commit, los cambios no se guardan 
    except psycopg2.Error as e:
        log.error(f"1.0. Ocurrio un error al insertar: {e}")
    finally:
        cursor.close()
        conexion.close()


def principal():
    url = config['API']['UrlApi']
    urlwsp = config['API']['UrlApiWapp']
    log.debug(f"Url Google: [{url}] Url Whatsapp: [{urlwsp}]" )
    query = config.get('QUERY', 'sql').strip().replace('\n', ' ')
    fecha1 = fecha()
    query = query.strip().replace(':fecha', "'"+str(fecha1)+"'")
    IdArchivo = datetime.datetime.now().strftime('%Y-%m-%d_%H%M%S')
    
    log.debug(f"fecha revision: {fecha1}")
    log.debug(f"query: {query}" )
    contenJson = LeeApi(url,fecha1)
    log.debug(f"Response: {contenJson} ") 
    if contenJson != 500 :
        nomCArgue = "nomArc_"+IdArchivo
        insertaDB(contenJson,nomCArgue,query)
        log.debug(f"Ejecucion SP inserta detalle de calendario: " )
        #lee_-sql_envia_msg(query)
    else:
        log.error(f"No pudo obtener respuesta del API de Google Calendario {contenJson} ")
        #lee_sql_envia_msg(query)
    log.info(' ...FIN PROCESO ...')


if __name__ == '__main__':
    log.info(' ******** Iniciando Programa ENVIO DE MENSAJES ******** ')
    byRange = config.getboolean('SCHEDULE', 'byRange')
    byHour = config.getboolean('SCHEDULE', 'byHour')
    
    while True:     
        if byRange: 
            if dm.demonbyRange():
                principal()
        if byHour: 
            archivohorario = config['SCHEDULE']['archivohorario']
            if dm.demonbyHour(archivohorario):
                principal()
        time.sleep(60) # tiempo espera para la siguiente validacion (60) es un minuto


    
