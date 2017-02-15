import os
import sys

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import TIMESTAMP
from sqlalchemy import Table
from sqlalchemy import func
from sqlalchemy import MetaData

metadata = MetaData()

VALIDATION_CODES = Table(
    'validation_codes', metadata,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('user_id', Integer),
    Column('code', String(10)),
    Column('status', String(10)),
    Column('created_at', TIMESTAMP, server_default=func.now()),
    Column('updated_at', TIMESTAMP, server_default=func.now(), onupdate=func.current_timestamp())
)

def upgrade(migrate_engine):
    metadata.bind = migrate_engine
    VALIDATION_CODES.create()


def downgrade(migrate_engine):
    metadata.bind = migrate_engine
    VALIDATION_CODES.drop()
