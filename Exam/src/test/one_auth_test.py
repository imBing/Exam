import sys
import os

from helper.test_helper import create_user_and_get_token, basic_auth

myPath = os.path.dirname(os.path.abspath(__file__))
sys.path.append(myPath + "/../src/")

import unittest
import json
import one_auth
from unittest.mock import MagicMock
from unittest.mock import patch

from db.connection import get_db_session
from flask_mail import Mail
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService
from one_auth import APP


class OneAuthTests(unittest.TestCase):
    def setUp(self):
        os.environ['ONE_AUTH_ENV'] = 'test'
        APP.config['TESTING'] = True
        self.app = APP.test_client()
        self.mail = Mail(APP)
        self.db_connection = get_db_session(APP.db_engine)
        self.user_service = UserService(self.db_connection)
        self.validation_code_service = ValidationCodeService(self.db_connection)

    def test_should_return_415_while_not_passing_json(self):
        data = '{"email": "xxx@test.com"}'
        response = self.app.post('/one_auth/api/user', data=data, content_type='application/xml')
        self.assertEquals(415, response.status_code)

    def test_should_return_400_if_the_any_mandatory_field_is_not_exist_in_request_when_update_the_user_password(self):
        self.user_service.delete_user('xxx@test.com')
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda: '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')

        update_data = '{"email": "xxx@test.com", "validation_code": "123456"}'
        response = self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')
        self.assertEquals(400, response.status_code)

        update_data = '{"email": "xxx@test.com", "password": "password"}'
        response = self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')
        self.assertEquals(400, response.status_code)

    def test_update_user_password(self):
        self.user_service.delete_user('xxx@test.com')
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda: '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')

        update_data = '{"email": "xxx@test.com", "validation_code": "123456", "password": "password1"}'

        response = self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')

        self.db_connection.commit()
        created_user = self.user_service.get_user('xxx@test.com')
        response_json = json.loads(response.data.decode('utf8'))
        self.assertEquals(200, response.status_code)
        self.assertEquals('active', created_user.status)
        self.assertIsNotNone(response_json['access_token'])
        self.assertIsNotNone(created_user.password)

    def test_update_user_password_when_password_in_wrong_format(self):
        self.user_service.delete_user('xxx@test.com')
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda: '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')

        update_data = '{"email": "xxx@test.com", "validation_code": "123456", "password": "password"}'

        response = self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')

        # self.assertEquals(400, response.status_code)

    def test_create_and_get_user(self):
        self.user_service.delete_user('test@one-auth.com')
        user = self.user_service.create_user('test@one-auth.com')

        assert 'test@one-auth.com' == user.email
        self.user_service.delete_user('test@one-auth.com')

    def test_should_return_access_token_when_login_with_correct_email_and_password(self):
        some_email = 'xxx@test.com'
        self.user_service.delete_user(some_email)
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda : '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')

        update_data = '{"email": "xxx@test.com", "validation_code": "123456", "password": "password1"}'

        response = self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')

        response = self.app.get('/one_auth/api/access_tokens', content_type='application/json',

                                headers={'Authorization': 'Basic eHh4QHRlc3QuY29tOnBhc3N3b3JkMQ=='})

        result_data = json.loads(response.data.decode('utf8'))

        self.assertEquals(200, response.status_code)
        self.assertIsNotNone(result_data['access_token'])

        self.user_service.delete_user(some_email)

    def test_should_return_401_when_login_with_incorrect_email_and_password(self):
        some_email = 'xxx@test.com'
        self.user_service.delete_user(some_email)
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda : '123456'):
            self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')

        update_data = '{"email": "xxx@test.com", "validation_code": "123456", "password": "password"}'

        self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')
        response = self.app.get('/one_auth/api/access_tokens', content_type='application/json',
                                headers={'Authorization': 'Basic OmFhYWE='})

        self.assertEquals(401, response.status_code)
        self.user_service.delete_user(some_email)

    def test_should_return_200_when_access_token_validation_success(self):
        access_token = create_user_and_get_token('validation@test.com')
        authorization = basic_auth('validation@test.com', access_token)

        response = self.app.get('/one_auth/api/validations', headers={
            'Authorization': authorization
        })

        self.assertEquals(200, response.status_code)

        result_data = json.loads(response.data.decode('utf8'))
        self.assertEquals('validation@test.com', result_data['email'])
        self.assertEquals('', result_data['first_name'])
        self.assertEquals('', result_data['last_name'])
        self.assertEquals('', result_data['country'])
        self.assertEquals('', result_data['department'])
        self.assertEquals('', result_data['avatar'])

    @patch('one_auth.UserService')
    def test_should_return_401_when_access_token_validation_fail(self, mock_user_service):
        mock_user_service.encode_access_token_for = MagicMock(return_value='invalid_token')

        response = self.app.get('/one_auth/api/validations', headers={
            'Authorization': 'Basic eHh4QHRlc3QuY29tOnRlc3RfdG9rZW4='
        })

        self.assertEquals(401, response.status_code)
