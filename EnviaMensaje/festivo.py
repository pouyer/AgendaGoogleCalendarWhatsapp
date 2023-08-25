import holidays_co
from datetime import date, timedelta

#holidays = holidays_co.get_colombia_holidays_by_year(2023)
#fecha_actual = date.today()

fecha_actual = date('2023-07-06')
fecha = fecha_actual + timedelta(days=0)

print(f"Es festivo {fecha} :{holidays_co.is_holiday_date(fecha)}")