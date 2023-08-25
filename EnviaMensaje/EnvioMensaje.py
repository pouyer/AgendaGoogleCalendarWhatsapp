import requests
import time 
import log
import configparser

# Lee las variables de conexión y otras configuraciones desde el archivo de configuración
config = configparser.ConfigParser()
config.read('./config/config.ini')


def sendMessage(url, para, mensaje):
    #url = 'http://localhost:3001/lead'
    
    data = {
        "message": mensaje,
        "phone": para
    }
    headers = {
        'Content-Type':'application/json'
    }
    #print(data)
    log.debug(f"data: {data}")
    try:
        response = requests.post(url, json=data, headers=headers)
        log.debug(f"Resultado de la transaccion sendMessage: {response}")
        time.sleep(int(config['MENSAJES']['mensagetime']))
    except Exception as e: # Manejo de la excepción
        log.error(f"smg 1.0.0 En sendMessage excepción: {str(e)}")
        
    return response