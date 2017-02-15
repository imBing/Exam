import bcrypt
from sqlalchemy import Table, Integer, Column, String, TIMESTAMP, func
from sqlalchemy.orm import mapper

from db.connection import METADATA


class User:
    def __init__(self, email=None):
        self.email = email
        self.status = 'deactived'
        self.password, self.access_token = None, None
        self.first_name, self.last_name, self.country, self.department, self.avatar \
            = None, None, None, None, None

    def update_credential(self, password=None, access_token=None):
        if password is not None:
            password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(10))
        self.password = password.decode('utf-8')
        self.access_token = access_token

    def check_password(self, password):
        try:
            status = bcrypt.checkpw(
                '{}'.format(password).encode('utf-8'),
                '{}'.format(self.password).encode('utf-8')
            )
        except ValueError:
            status = False
        return status

    def active(self):
        return self.status == 'active'

    def update_profile(self, profile):
        self.first_name = profile.get('first_name', self.first_name)
        self.last_name = profile.get('last_name', self.last_name)
        self.country = profile.get('country', self.country)
        self.department = profile.get('department', self.department)
        self.avatar = profile.get('avatar', self.avatar)

    def serialize(self):
        return {
            'email': self.email or '',
            'first_name': self.first_name or '',
            'last_name': self.last_name or '',
            'country': self.country or '',
            'avatar': self.avatar or '',
            'department': self.department or ''
        }


USERS = Table(
    'users', METADATA,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('email', String(40)),
    Column('name', String(40)),
    Column('password', String(40)),
    Column('status', String(10)),
    Column('first_name', String(40)),
    Column('last_name', String(40)),
    Column('country', String(40)),
    Column('department', String(40)),
    Column('avatar', String(256)),
    Column('created_at', TIMESTAMP, server_default=func.now()),
    Column('updated_at', TIMESTAMP, server_default=func.now(), onupdate=func.current_timestamp()),
    Column('access_token', String(256))
)

mapper(User, USERS)
