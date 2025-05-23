from django.urls import path
from core.views import health_check

urlpatterns = [
    path('health/', health_check),
    # ... other paths
]