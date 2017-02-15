import base64
import json
import os
import unittest

from db.connection import get_db_session
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService
from one_auth import APP


class APICreateUser(unittest.TestCase):
    def setUp(self):
        os.environ['ONE_AUTH_ENV'] = 'test'
        APP.config['TESTING'] = True
        self.app = APP.test_client()

        self.db_connection = get_db_session(APP.db_engine)
        self.user_service = UserService(self.db_connection)
        self.validation_code_service = ValidationCodeService(self.db_connection)
        self.create_user("existinguser@company.com")

    def tearDown(self):
        self.delete_user('someone@company.com')
        self.delete_user('existinguser@company.com')

    def create_user(self, email):
        return self.app.post('/one_auth/api/user',
                             data='{"email": "' + email + '"}',
                             content_type='application/json')

    def test_should_log_out(self):
        some_email = 'xxx@test.com'
        # self.user_service.delete_user(some_email)
        self.app.post('/one_auth/api/user', data='{"email": "xxx@test.com"}', content_type='application/json')
        self.user_service = UserService(self.db_connection)
        #
        update_data = '{"email": "xxx@test.com", "validation_code": "%s", "password": "password1"}' % \
                      111111

        self.app.put('/one_auth/api/user', data=update_data, content_type='application/json')

        response = self.app.get('/one_auth/api/access_tokens', content_type='application/json',

                                headers={'Authorization': 'Basic eHh4QHRlc3QuY29tOnBhc3N3b3JkMQ=='})

        result_data = json.loads(response.data.decode('utf8'))
        self.assertEqual(200, response.status_code)
        self.assertIsNotNone(result_data['access_token'])
        access_token = some_email + ':' + result_data['access_token']
        auth = base64.b64encode(access_token.encode('utf-8')).decode('utf-8')

        basic_auth = 'Basic {}'.format(auth)
        response = self.app.delete('/one_auth/api/access_tokens',
                                   headers={'Authorization': basic_auth})

        self.assertEquals(200, response.status_code)
        user = self.user_service.get_user(some_email)
        self.assertIsNone(user.access_token)

        response = self.app.get('/one_auth/api/validations', headers={
            'Authorization': basic_auth
        })

        self.assertEquals(401, response.status_code)

        response = self.app.get('/one_auth/api/access_tokens', content_type='application/json',

                                headers={'Authorization': 'Basic eHh4QHRlc3QuY29tOnBhc3N3b3JkMQ=='})
        self.assertEquals(200, response.status_code)


    def delete_user(self, email):
        UserService(get_db_session(APP.db_engine)).delete_user(email)
