from functions.get_service import get_calendar_service
from responses.response_json import response_json
from datetime import datetime, timedelta
import time


service = get_calendar_service()


def create_event(template: dict):
    try:
        response = service.events().insert(calendarId="primary", body=template).execute()
        return response
    except Exception as e:
        return response_json(message=e.message, status=500)

def list_event(fecha):
    try:
        page_token = None 
        hora_ini ='08:00'
        hora_fin ='19:00'
        
        date_ini = fecha +' '+ hora_ini + '-05:00'
        #date_ini='2023-07-17T13:20:00-05:00'
        horaInicial = datetime.fromisoformat(date_ini).isoformat()
        print(horaInicial)
        date_fin = fecha +' '+ hora_fin + '-05:00'
        #date_fin='2023-07-17T18:20:00-05:00'
        horaFinal = datetime.fromisoformat(date_fin).isoformat()
        print(horaFinal)
        response = service.events().list(calendarId='primary', pageToken=page_token, showDeleted=False, timeMin=horaInicial, timeMax=horaFinal).execute()
        #response = service.events().list(calendarId='primary', pageToken=page_token, showDeleted=False).execute()
        #for event in response['items']:
        #    print (event['summary'])
        #page_token = response.get('nextPageToken')
        #if not page_token:
        #    break
        return response
    except Exception as e:
        return response_json(message=e.message, status=500)        

def get_event(eventId: str):
    try:
        response = service.events().get(calendarId="primary", eventId=eventId).execute()
        return response
    except Exception as e:
        return response_json(message=e.message, status=500)


def delete_event(eventId: str):
    try:
        response = service.events().delete(calendarId="primary", eventId=eventId).execute()
        return response
    except Exception as e:
        return response_json(message=e.message, status=500)


def update_event(eventId: str, template: dict):
    try:
        response = service.events().update(calendarId='primary',
                                           eventId=eventId, body=template).execute()
        return response
    except Exception as e:
        return response_json(message=e.message, status=500)
