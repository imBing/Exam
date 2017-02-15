import sys
import os
import unittest
import json
import one_auth

from db.connection import get_db_session
from helper.test_helper import create_user_and_get_token, basic_auth
from service.email_request_service import EmailRequestServcie

myPath = os.path.dirname(os.path.abspath(__file__))
sys.path.append(myPath + "/../src/")

from unittest.mock import patch
from flask_mail import Mail
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService
from one_auth import APP
from ddt import ddt, data


@ddt
class APIUserTest(unittest.TestCase):
    def setUp(self):
        os.environ['ONE_AUTH_ENV'] = 'test'
        APP.config['TESTING'] = True

        self.app = APP.test_client()
        self.mail = Mail(APP)
        self.init_services()
        self.delete_user('existing_deactivated_user@company.com')
        self.user_service.create_user('existing_deactivated_user@company.com')
        self.delete_user('existing_active_user@company.com')
        existing_user = self.user_service.create_user('active_profiled_user@company.com')
        self.user_service.activate_user(existing_user)
        self.user_service.update_user(existing_user, {'first_name': 'FirstName'})

        existing_unprofiled_user = self.user_service.create_user('active_unprofiled_user@company.com')
        self.user_service.activate_user(existing_unprofiled_user)

    def tearDown(self):
        self.delete_user('someone@company.com')
        self.delete_user('existing_deactivated_user@company.com')
        self.delete_user('existing_active_user@company.com')

    @data(
        [201, 'post', 'application/json', '{"email": "someone@company.com"}'],
        [201, 'post', 'application/json', '{"email": "existing_deactivated_user@company.com"}'],
        [400, 'post', 'application/json', '{}'],
        [415, 'post', 'application/text', '{"email": "someone@company.com"}'],
        [422, 'post', 'application/json', '{"email": "active_profiled_user@company.com"}'],
        [201, 'post', 'application/json', '{"email": "active_unprofiled_user@company.com"}'],
    )
    def test_spec(self, testData):
        expect_status_code, method, content_type, data = testData
        response = getattr(self.app, method)('/one_auth/api/user', data=data, content_type=content_type)
        self.assertEquals(expect_status_code, response.status_code)

    def test_should_create_user_and_send_email_once_invoke_api(self):
        email = "someone@company.com"
        with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda: '123456'):
            with self.mail.record_messages() as outbox:
                response = self.app.post('/one_auth/api/user',
                                         data='{"email": "' + email + '"}',
                                         content_type='application/json')

            result_data = json.loads(response.data.decode('utf8'))
            self.assertEquals(201, response.status_code)
            self.assertEquals(email, result_data['email'])
            self.assertEquals('deactived', result_data['status'])
            self.assertEmailHasBeenSent(outbox)
            self.assertEmailRequestHasBeenRecord(email)
            self.assertValidationCodeHasBeenGenerated('123456')

    def test_update_user_profile(self):
        access_token = create_user_and_get_token('test_email@one-auth.com')
        headers = {'Authorization': basic_auth('test_email@one-auth.com', access_token)}
        update_data = '{"first_name": "Jennifer", ' \
                      '"last_name": "Lee", ' \
                      '"country": "China", ' \
                      '"department": "BSC", ' \
                      '"avatar": "http://testurl/image.png"}'

        response = self.app.put('/one_auth/api/user/profile',
                                data=update_data,
                                content_type='application/json',
                                headers=headers)

        self.assertEquals(200, response.status_code)

        result_data = json.loads(response.data.decode('utf8'))
        self.assertEquals('test_email@one-auth.com', result_data['email'])
        self.assertEquals('Jennifer', result_data['first_name'])
        self.assertEquals('Lee', result_data['last_name'])
        self.assertEquals('China', result_data['country'])
        self.assertEquals('BSC', result_data['department'])
        self.assertEquals('http://testurl/image.png', result_data['avatar'])
        self.assertIsNotNone(result_data['access_token'])

    def test_token_changed_while_updating_user_profile(self):
        access_token = create_user_and_get_token('test_email@one-auth.com')

        headers = {'Authorization': basic_auth('test_email@one-auth.com', access_token)}
        update_data = '{"first_name": "Jennifer", ' \
                      '"last_name": "Lee", ' \
                      '"country": "China", ' \
                      '"department": "BSC", ' \
                      '"avatar": "http://testurl/image.png"}'

        response = self.app.put('/one_auth/api/user/profile',
                                data=update_data,
                                content_type='application/json',
                                headers=headers)
        self.assertEquals(200, response.status_code)

        response = self.app.get('/one_auth/api/access_tokens', content_type='application/json',
                           headers={'Authorization': basic_auth('test_email@one-auth.com', 'password1')})
        response_data = json.loads(response.data.decode('utf8'))
        self.assertNotEquals(access_token, response_data['access_token'])
        self.assertEquals({
            'first_name': 'Jennifer',
            'last_name': 'Lee',
            'country': 'China',
            'department': 'BSC',
            'avatar': 'http://testurl/image.png',
            'email': 'test_email@one-auth.com'
        },  response_data['user_profile']
        )

    def assertValidationCodeHasBeenGenerated(self, code):
        validation_code = self.validation_code_service.get_validation_code(code)
        self.assertEquals(6, len(validation_code.code))
        self.assertEquals('active', validation_code.status)

    def assertEmailHasBeenSent(self, outbox):
        self.assertEquals(1, len(outbox))
        self.assertEquals('VALIDATION CODE', outbox[0].subject)

    def assertEmailRequestHasBeenRecord(self, email):
        request_email = self.email_request_service.find_by_email(email)
        self.assertEquals(email, request_email.email)
        self.assertEquals('123456', request_email.validation_code)
        self.assertEquals("not_send", request_email.status)

    def create_user(self, email):
        return self.app.post('/one_auth/api/user',
                             data='{"email": "' + email + '"}',
                             content_type='application/json')

    def delete_user(self, email):
        self.user_service.delete_user(email)
        self.email_request_service.delete(email)

    def init_services(self):
        self.db_connection = get_db_session(APP.db_engine)
        self.user_service = UserService(self.db_connection)
        self.validation_code_service = ValidationCodeService(self.db_connection)
        self.email_request_service = EmailRequestServcie(self.db_connection)
