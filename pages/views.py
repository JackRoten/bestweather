# pages/views.py
from django.views.generic import TemplateView
import requests
import json

class HomeView(TemplateView):
    template_name = "pages/home.html"

# TODO: Update functions to access NOAA data and correctly display it
# in views.
# TODO: Add tests to see if functions are working.
def get_weather_data(latitude, longitude):
    """
    Gather weather data for location
    """
    headers = {"User-Agent": f"(bestweatherwa.com, thejackroten@gmail.com)"}
    meta_url = f"https://api.weather.gov/points/{latitude},{longitude}"
    meta_response = requests.get(url=meta_url, headers=headers)
    location_url = json.loads(meta_response.text)['properties']['forecastGridData']
    forecast_response = requests.get(url=location_url, headers=headers)
    json_data = json.loads(forecast_response.text)
    return json_data

def weather_view(request):
    """
    Display weather data
    """
    latitude = "39.7456"
    longitude = "-97.0892"
    weather_data = get_weather_data(latitude, longitude)
    print(latitude)
    print(weather_data)
    context = {'weather_data': weather_data}
    return render(weather_data, "weather_template.html")