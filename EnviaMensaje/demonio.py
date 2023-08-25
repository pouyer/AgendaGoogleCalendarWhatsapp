import configparser
import log
import time
import datetime
from datetime import date, timedelta
import holidays_co




#holidays = holidays_co.get_colombia_holidays_by_year(2023)
#fecha_actual = date.today()

# Lee las variables de conexión y otras configuraciones desde el archivo de configuración
config = configparser.ConfigParser()
config.read('./config/config.ini')

def diaTipo(fecha :date):
    if holidays_co.is_holiday_date(fecha):
        log.debug(f"diaTipo Holyday: 'True' dia tipo: {str(fecha.weekday())}  es Festivo")
        return 7
    else :
        log.debug(f"diaTipo Holyday: 'False' dia tipo: {str(fecha.weekday())}  NO es Festivo")
        return fecha.weekday()


def diaExepcion(fecha_actual :date):
    # Obtener la fecha del día actual
    #fecha_actual = date.today()
    fecha = fecha_actual + timedelta(days=0)
    if holidays_co.is_holiday_date(fecha):
        log.debug(f"diaExepcion: 'True' dia tipo: {str(fecha.weekday())}  es Festivo")
        return True
    else :
        listdia = config['SCHEDULE']['exepDias'] 
    # El 6 representa el domingo (lunes es 0, martes es 1, y así sucesivamente)
        if str(fecha.weekday()) in  listdia:  
            log.debug(f"diaExepcion: 'True' fecha_actual: {str(fecha.weekday())}  listdia {listdia}")
            return True
        else :
            log.debug(f"diaExepcion: 'False' fecha_actual: {str(fecha.weekday())}  listdia {listdia}")
            return False

def demonbyHour(ArchivoHoras):
    #leemos el archivo con las horas de ejecucion
    f = open(ArchivoHoras, "r")
    HorasEjecucion = f.readlines()
    f.close()
    # obtenemos la hora actual
    horaActual = time.strftime("%H:%M")
    # recorremos la lista de horas de ejecucion
    log.debug(f"HorasEjecucion: {HorasEjecucion}")
    for horaEjecucion in HorasEjecucion:
        log.debug(f"horaActual: {horaActual} horaEjecucion: {horaEjecucion.rstrip()}  ")
        # vemos si la hora actual es la hora de ejecucion
        if horaActual == horaEjecucion.rstrip():
            # si es la hora de ejecucion, ejecutamos la tarea
            log.info('--demonbyHour Ingresa a procesas por Archivo Horario')
            return True
    return False  
   
        

def demonbyRange():
    start_hour = int(config['SCHEDULE']['start_hour'])
    end_hour = int(config['SCHEDULE']['end_hour'])
    listminute = config['SCHEDULE']['minute'] 
    log.debug(f'start_hour:{start_hour} end_hour:{end_hour} listminute:{[listminute]} ')
    now = datetime.datetime.now()
    log.debug(f'now.hour:{now.hour} now.minute:{int(now.minute)} ')
    if ((start_hour <= now.hour < end_hour) and (str(now.minute) in listminute)):
        log.debug(' --demonbyRange  Ingresa a procesas por Rango-- ')
        return True
    return False
        