import requests

year = 2023
url = f"https://www.calendarioscolombia.com/api/v1/holidays/{year}"

response = requests.get(url)
if response.status_code == 200:
    holidays = response.json()
    for holiday in holidays:
        print(holiday["name"], holiday["date"])
else:
    print("Error al consumir el API.")