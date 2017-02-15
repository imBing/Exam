import random
import string

from itsdangerous import JSONWebSignatureSerializer

class AuthenticationService:
    @staticmethod
    def generate_token(size=20, chars=string.ascii_uppercase + string.digits):
        return ''.join(random.choice(chars) for _ in range(size))


    @staticmethod
    def encode_token_for(user):
        serializer = JSONWebSignatureSerializer(user.access_token)
        return str(serializer.dumps(user.email), 'utf-8')
