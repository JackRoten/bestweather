from django.test import TestCase
from pages.views import get_weather_data 

# Create your tests here.

class ViewsTest(TestCase):
    def test_get_weather_data(self):
        latitude = "39.7456"
        longitude = "-97.0892"
        request = get_weather_data(latitude, longitude)
        gridX = "32"
        request_gridX = request["properties"]["gridX"]
        self.assertEqual(request_gridX, gridX)
