import unittest

from service.authentication_service import AuthenticationService

class AuthenticationServiceTest(unittest.TestCase):
    def test_token_generator(self):
        token = AuthenticationService.generate_token()
        self.assertEqual(20, len(token))