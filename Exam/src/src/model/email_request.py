from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Table
from sqlalchemy.orm import mapper

from db.connection import METADATA


class EmailRequest:
    def __init__(self, email, validation_code, status="not_send"):
        self.email = email
        self.validation_code = validation_code
        self.status = status


EMAIL_REQUESTS = Table(
    'email_requests', METADATA,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('email', String(10)),
    Column('validation_code', String(10)),
    Column('status', String(10))
)

mapper(EmailRequest, EMAIL_REQUESTS)
