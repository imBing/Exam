import os
import unittest

from flask import json
from db.connection import get_db_session
from helper.test_helper import create_user_and_get_token, basic_auth
from service.user_service import UserService
from setting import APP


class APIImageTest(unittest.TestCase):
    def setUp(self):
        self.app = APP.test_client()
        UPLOAD_URL = '/images'
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        APP.config['UPLOAD_FOLDER'] = BASE_DIR + UPLOAD_URL
        self.db_connection = get_db_session(APP.db_engine)
        self.user_service = UserService(self.db_connection)

    def test_image_upload_api(self):
        access_token = create_user_and_get_token('xxx@test.com')

        authorization = basic_auth('xxx@test.com', access_token)
        response = self.app.post('/one_auth/api/images',
                                 data={'file': open(os.path.dirname(os.path.abspath(__file__)) + '/test_image.png',
                                                    'rb')},
                                 headers={'Authorization': authorization}
                                 )
        self.assertEquals(201, response.status_code)

        response_json = json.loads(response.data)
        self.assertTrue(
            response_json['url'].startswith('%s' % APP.config['IMAGE_BASE_URL']))
