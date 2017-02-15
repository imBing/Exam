from sqlalchemy import Table
from sqlalchemy import Column
from sqlalchemy import MetaData
from sqlalchemy import String


def upgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    users = Table('users', metadata, autoload=True)
    email_column = Column('access_token', String(256))
    email_column.create(users)


def downgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    account = Table('users', metadata, autoload=True)
    account.c.access_token.drop()
