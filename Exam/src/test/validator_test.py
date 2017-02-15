import os
import sys

from validator import NotEmpty

sys.path.append(os.getcwd() + "/src")

import unittest


class ValidatorTest(unittest.TestCase):
    def test_should_return_true_if_value_is_not_empty(self):
        self.assertEqual(True, NotEmpty.check_function('111'))

    def test_should_return_empty_when_get_error_with_not_empty_validator(self):
        self.assertEqual('empty', NotEmpty.get_error())
