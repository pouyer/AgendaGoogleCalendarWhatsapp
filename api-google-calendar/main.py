from fastapi import FastAPI
from routes.calendar import routes_calendar


app = FastAPI(title="API Calendario Consultorio CForero")

app.include_router(routes_calendar, prefix="/calendar")
