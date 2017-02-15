import base64
import os

from flask_mail import Mail

import one_auth

from unittest.mock import patch
from flask import json
from db.connection import get_db_session
from service.user_service import UserService
from setting import APP


def create_user_and_get_token(email):
    os.environ['ONE_AUTH_ENV'] = 'test'
    APP.config['TESTING'] = True
    app = APP.test_client()
    Mail(APP)

    db_connection = get_db_session(APP.db_engine)
    user_service = UserService(db_connection)

    user_service.delete_user(email)
    with patch.object(one_auth.ValidationCodeService, 'generate_validation_code', lambda: '123456'):
        app.post('/one_auth/api/user', data='{"email": "%s"}' % email, content_type='application/json')

    update_data = '{"email": "%s", "validation_code": "123456", "password": "password1"}' % email

    app.put('/one_auth/api/user', data=update_data, content_type='application/json')

    response = app.get('/one_auth/api/access_tokens', content_type='application/json',

                       headers={'Authorization': basic_auth(email, 'password1')})

    return json.loads(response.data.decode('utf8'))['access_token']


def basic_auth(email, access_token):
    return 'Basic ' + base64.b64encode(bytes('%s:%s' % (email, access_token), 'utf8')).decode('utf8')
