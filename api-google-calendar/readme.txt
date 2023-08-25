Para Video de explicacion:
https://www.youtube.com/watch?v=mfymn9qqLHg

Esta aplicacion tiene los paquetes 
fastapi  --> pip install fastapi
uvicorn  --> pip install uvicorn
se instalan los modulos de Google calendari de python:
pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib


#ejecuta el terminal (crt+r) digita cmd
#Activa el entorno virtual ejecutando la linea:
.\api-google-calendar\venv\Scripts\activate.bat
# Subir el servicio de Google Calendario 
cd api-google-calendar\
uvicorn main:app --reload 

# deactivate el entorno virtual ejecutando la linea:
#.\api-google-calendar\venv\Scripts\deactivate.bat


#Para iniciar el servicio en un puerto diferente al 8000 en el terminal ubicado en la carpeta princilar ejecutar:
>uvicorn main:app --reload --port=8001


