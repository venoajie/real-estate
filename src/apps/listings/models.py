# src/apps/listings/models.py
from django.db import models

class Listing(models.Model):

    class Meta:
        app_label = 'listings'
        
