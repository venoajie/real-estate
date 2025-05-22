from django.test import TestCase
from apps.listings.models import Listing

class ListingModelTest(TestCase):
    def test_creation(self):
        listing = Listing.objects.create(
            title="Test Property", 
            price=100000.00
        )
        self.assertEqual(listing.title, "Test Property")
        self.assertEqual(listing.price, 100000.00)
        self.assertEqual(str(listing), "Test Property")