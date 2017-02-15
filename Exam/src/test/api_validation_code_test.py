import sys
import os
import unittest
import json
import one_auth

myPath = os.path.dirname(os.path.abspath(__file__))
sys.path.append(myPath + "/../src/")

from unittest.mock import patch
from db.connection import get_db_session
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService

from one_auth import APP


class APIValidationCode(unittest.TestCase):
    def setUp(self):
        os.environ['ONE_AUTH_ENV'] = 'test'
        APP.config['TESTING'] = True
        self.app = APP.test_client()

        self.db_connection = get_db_session(APP.db_engine)
        self.user_service = UserService(self.db_connection)
        self.validation_code_service = ValidationCodeService(self.db_connection)
        self.user_service.delete_user('some_user@test.com')

    def test_use_last_validation_code_verify(self):
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda : '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "some_user@test.com"}', content_type='application/json')
        code_data = '{"email": "some_user@test.com", "validation_code": "123456"}'
        response = self.app.put('/one_auth/api/validation_code', data=code_data, content_type='application/json')

        self.assertEquals(200, response.status_code)
        self.assertEquals('active', self.validation_code_service.get_validation_code('123456').status)

    def test_return_422_if_code_is_invalid(self):
        self.app.post('/one_auth/api/user', data='{"email": "some_user@test.com"}', content_type='application/json')

        code_data = '{"email": "some_user@test.com", "validation_code": "invalid_code"}'
        response = self.app.put('/one_auth/api/validation_code', data=code_data, content_type='application/json')

        self.assertEquals(422, response.status_code)
