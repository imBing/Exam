import random
from model.validation_code import ValidationCode


class ValidationCodeService:
    def __init__(self, db_session):
        self.db_session = db_session

    def create_validation_code_for(self, user):
        validation_code = ValidationCode(user.id, ValidationCodeService.generate_validation_code())
        self.db_session.add(validation_code)
        self.db_session.commit()
        return validation_code

    @staticmethod
    def generate_validation_code():
        validation_code = ''
        for _ in range(6):
            validation_code += str(random.randint(0, 9))
        return validation_code

    def use_code(self, validation_code):
        if validation_code is None:
            return None
        validation_code.status = 'used'
        self.db_session.commit()
        return validation_code

    def get_validation_code(self, code):
        if code is None:
            return None
        return self.db_session.query(ValidationCode)\
            .filter_by(code=code)\
            .order_by(ValidationCode.id.desc())\
            .first()
