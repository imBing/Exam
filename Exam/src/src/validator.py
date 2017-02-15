import re
from functools import wraps

from flask import request, jsonify


class Validator:
    @classmethod
    def check_param(cls, items, value):
        for validator in cls.get_validators(items):
            if not validator.check_function(value):
                return False, validator.get_error()
        return True, ' '

    @classmethod
    def get_validators(cls, items):
        validators = items[1]
        return validators

    @classmethod
    def get_field(cls, items):
        field = items[0]
        return field


class NotEmpty:
    @staticmethod
    def check_function(value):
        return value is not None

    @staticmethod
    def get_error():
        return "empty"


class PasswordInCorrectFormat:
    def __init__(self):
        self.regex = re.compile("(?:(?:(?=.*[a-zA-Z])(?=.*\\d)))[a-zA-Z\\d]{6,20}")

    def check_function(self, value):
        if value is None or self.regex.search(value) is None:
            return False
        return True

    @staticmethod
    def get_error():
        return "not in correct format"


def valid_param(fields):
    def decorator(func):
        @wraps(func)
        def real_decorator(*args, **kwargs):
            content = request.json
            for items in fields.items():
                valid, message = Validator.check_param(items, content.get(items[0], None))
                if not valid:
                    return jsonify(message=(items[0]) + ' ' + message), 400
            return func(*args, **kwargs)

        return real_decorator

    return decorator
