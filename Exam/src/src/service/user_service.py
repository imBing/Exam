from itsdangerous import JSONWebSignatureSerializer

from model.user import User


class UserService:
    def __init__(self, db_session):
        self.db_session = db_session

    def set_credential(self, user, password, token):
        if user is None:
            return None

        user.update_credential(password=password, access_token=token)
        self.db_session.commit()
        return user

    def create_user(self, email):
        user = User(self.__parse_email(email))
        self.db_session.add(user)
        self.db_session.commit()
        return user

    def activate_user(self, user):
        user.status = 'active'
        self.db_session.commit()
        return user

    def update_user(self, user, profile):
        user.update_profile(profile)
        self.db_session.commit()
        return user

    def get_user(self, email) -> User:
        email = self.__parse_email(email)
        user = self.db_session.query(User).filter_by(email=email).first()
        return user

    def delete_user(self, email):
        email = self.__parse_email(email)
        users = self.db_session.query(User).filter_by(email=email).all()
        for user in users:
            self.db_session.delete(user)
        self.db_session.commit()

    def delete_access_token(self, email):
        email = self.__parse_email(email)
        user = self.get_user(email)
        user.access_token = None
        self.db_session.commit()

    @classmethod
    def encode_access_token_for(cls, user):
        if user.access_token is None:
            return None
        serializer = JSONWebSignatureSerializer(user.access_token)
        return str(serializer.dumps(user.email), 'utf-8')

    @classmethod
    def __parse_email(cls, email):
        return email.lower()

    def set_token(self, user, token):
        if user is None:
            return None
        user.access_token = token
        self.db_session.commit()
        return user
