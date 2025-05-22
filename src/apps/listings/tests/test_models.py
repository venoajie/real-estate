# src/apps/listings/tests/test_models.py
from django.test import TestCase
from apps.listings.models import Listing

class ListingModelTest(TestCase):
    def test_creation(self):
        listing = Listing.objects.create(title="Test", price=100000)
        self.assertEqual(str(listing), "Test")