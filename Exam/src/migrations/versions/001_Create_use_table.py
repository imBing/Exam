import os
import sys

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import TIMESTAMP
from sqlalchemy import Table
from sqlalchemy import func
from sqlalchemy import MetaData

sys.path.append(os.getcwd() + "/")

metadata = MetaData()

USERS = Table(
    'users', metadata,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('email', String(40)),
    Column('name', String(40)),
    Column('password', String(40)),
    Column('status', String(10)),
    Column('created_at', TIMESTAMP, server_default=func.now()),
    Column('updated_at', TIMESTAMP, server_default=func.now(), onupdate=func.current_timestamp())
)


def upgrade(migrate_engine):
    metadata.bind = migrate_engine
    USERS.create()


def downgrade(migrate_engine):
    metadata.bind = migrate_engine
    USERS.drop()
