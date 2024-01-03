# pages/views.py
from django.views.generic import TemplateView
from django.shortcuts import render
from .models import MyData
import requests
import json


class HomeView(TemplateView):
    template_name = "pages/home.html"

# TODO: Update functions to access NOAA data and correctly display it
# in views.
# TODO: Add tests to see if functions are working.

def display_data(request):
    data = MyData.objects.first()
    context = {'data': data}
    return render(request, "templates/pages/home.html", context)


# def get_weather_data(latitude, longitude):
#     """
#     Gather weather data for location
#     """
#     headers = {"User-Agent": f"(bestweatherwa.com, thejackroten@gmail.com)"}
#     meta_url = f"https://api.weather.gov/points/{latitude},{longitude}"
#     meta_response = requests.get(url=meta_url, headers=headers)
#     location_url = json.loads(meta_response.text)['properties']['forecastGridData']
#     forecast_response = requests.get(url=location_url, headers=headers)
#     json_data = json.loads(forecast_response.text)
#     return json_data

# def weather_view(request):
#     """
#     Display weather data
#     """
#     latitude = "39.7456"
#     longitude = "-97.0892"
#     forecast_data = get_weather_data(latitude, longitude)
#     weather_data = {"latitude": latitude, "longitude": longitude}
#     context = {'weather_data': weather_data}
#     return render(request, "templates/pages/home.html", context)