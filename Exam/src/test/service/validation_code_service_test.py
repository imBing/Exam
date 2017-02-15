import unittest

from one_auth import DBConnector
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService
from setting import APP
from db.connection import get_db_session


class ValidationCodeServiceTest(unittest.TestCase):
    def test_create_validation_code_for(self):
        with DBConnector() as db_session:
            UserService(get_db_session(APP.db_engine)).delete_user('test@one-auth.com')
            user = UserService(db_session).create_user('test@one-auth.com')
            validation_code = ValidationCodeService(db_session).create_validation_code_for(user)
            assert validation_code.user_id == user.id

    def test_validation_code_generation(self):
        assert 6 == len(ValidationCodeService.generate_validation_code())

    def test_validation_code_used(self):
        UserService(get_db_session(APP.db_engine)).delete_user('test@one-auth.com')
        user = UserService(get_db_session(APP.db_engine)).create_user('test@one-auth.com')
        validation_code_service = ValidationCodeService(get_db_session(APP.db_engine))

        validation_code = validation_code_service.create_validation_code_for(user)
        validation_code_service.use_code(validation_code)

        self.assertEquals('used', validation_code.status)
