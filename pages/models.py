from django.db import models

# Create your models here.
class MyData(models.Model):
    var1 = models.CharField(max_length=255)
    var2 = models.CharField(max_length=255)