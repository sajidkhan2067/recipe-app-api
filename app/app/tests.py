"""
Sample tests
"""

from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):
    def test_add_numbers(self):
        self.assertEqual(calc.add(3, 8), 11)

    def test_subtract_numbers(self):
        self.assertEqual(calc.subtract(5, 11), 6)

    # def test_subtract_numbers_negative(self):
    #     self.assertEqual(calc.subtract(11, 15), -6)
