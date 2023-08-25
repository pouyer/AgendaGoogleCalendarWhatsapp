'''
Esta libreria maneja el Log de una aplicacion modo de uso:
debe cearse un archivo de configuracion llamado ('config.ini')
dentro de este archivo debe existir algo asi:
---
#Variables de configuracion del Log
[LOGG]
LogFile = .\\log\\SQLaExel
LogLevel = DEBUG   
#FormatDatetime = %Y-%m-%d %H:%M:%S
---
donde la variables:
LogFile: <define la ruta y el nombre del log. la aplicacion pone al final del nombre del log la fecha y hora con la extencion .log>
LogLevel: <es el nivel del Log que deseo que guarde en el archivo de Log. DEBUG, INFO, WARNING, ERROR> 
En los programas que se desee incluir el manejo de log se debe importar esta libreria
import log

para grabar los mensajes de Log se utiliza de la siguiente format
log.debug('Mensaje a mostrar como DEBUG')
log.info('Mensaje a mostrar como INFO')
log.warning('Mensaje a mostrar como WARNING')
log.error(f'Mensaje a mostrar como ERROR {vriables de error}')

en el proyecto que utilice esta libreria debe importar el package : configparser
ejecuta: pip install configparser
--------------------------------------------------------------------
   Fecha        |          Autor            |        Nota
--------------------------------------------------------------------   
   03/05/2023   |    Carlos Mejia           |   Version inicial  
'''
import datetime
import configparser
import os
import sys
# carga el archivo de configuracion en variables globales
config = configparser.ConfigParser()
config.read('./config/config.ini')

# variables manejo de archivo de log
#log_file = config['LOGG']['LogFile']+datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'.log'
log_file = config['LOGG']['LogFile']+datetime.datetime.now().strftime("%Y-%m-%d")+'.log'
log_level = config['LOGG']['LogLevel']
#FormatDatetime = config['LOGG']['FormatDatetime']

PathLog, nombre_archivo = os.path.split(log_file)


# configurar el nivel de log
log_levels = {'DEBUG': 10, 'INFO': 20, 'WARNING': 30, 'ERROR': 40}
level = log_levels[log_level]


# configurar el archivo de log
if os.path.exists(log_file):
    os.remove(log_file)
# crea la ruta del Log si no existe
if not os.path.exists(PathLog):
    os.makedirs(PathLog)

def log(msg, log_file, levelmsg):
    nivel = log_levels[levelmsg]
    if nivel >= level :
        time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        #time = datetime.datetime.now().strftime(FormatDatetime)
        log_msg = f'[{time}] [{levelmsg}] {msg}\n'
        try:
            with open(log_file, 'a') as f:
                f.write(log_msg)
        except Exception as e:
            print(f'ERROR al escribir el archivo de log. MsgError:{str(e)}')
            sys.exit(1)
            
def info(msg):
    log(msg, log_file, 'INFO')
    
def debug(msg):
    log(msg, log_file, 'DEBUG')    
    
def error(msg):
    log(msg, log_file, 'ERROR') 
    
def warning(msg):
    log(msg, log_file, 'WARNING')     