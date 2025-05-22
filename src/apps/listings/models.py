from django.db import models

class Listing(models.Model):
    title = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    # Add other fields as needed
    
    def __str__(self):
        return self.title

    class Meta:
        app_label = 'listings'