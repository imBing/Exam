from sqlalchemy import Table, Integer, Column, String, TIMESTAMP, func
from sqlalchemy.orm import mapper

from db.connection import METADATA


class ValidationCode():
    def __init__(self, user_id, code):
        self.user_id = user_id
        self.code = code
        self.status = 'active'


VALIDATION_CODES = Table(
    'validation_codes', METADATA,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('user_id', Integer),
    Column('code', String(10)),
    Column('status', String(10)),
    Column('created_at', TIMESTAMP, server_default=func.now()),
    Column('updated_at', TIMESTAMP, server_default=func.now(), onupdate=func.current_timestamp())
)

mapper(ValidationCode, VALIDATION_CODES)
