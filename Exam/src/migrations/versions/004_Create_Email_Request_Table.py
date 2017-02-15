from sqlalchemy import *
from migrate import *
from sqlalchemy import MetaData

metadata = MetaData()

EMAIL_REQUESTS = Table(
    'email_requests', metadata,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('email', String(50)),
    Column('validation_code', String(10)),
    Column('status', String(10))
)

def upgrade(migrate_engine):
    metadata.bind = migrate_engine
    EMAIL_REQUESTS.create()


def downgrade(migrate_engine):
    metadata.bind = migrate_engine
    EMAIL_REQUESTS.drop()
