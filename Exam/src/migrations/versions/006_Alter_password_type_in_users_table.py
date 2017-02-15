from sqlalchemy import *


def upgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    users = Table('users', metadata, autoload=True)
    users.c['password'].alter(type=Text)


def downgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    users = Table('users', metadata, autoload=True)
    users.c['password'].alter(type=String(40))
