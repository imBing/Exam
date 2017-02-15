from sqlalchemy import *


def upgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    users = Table('users', metadata, autoload=True)
    first_name_column = Column('first_name', String(40))
    first_name_column.create(users)
    last_name_column = Column('last_name', String(40))
    last_name_column.create(users)
    country_column = Column('country', String(40))
    country_column.create(users)
    department_column = Column('department', String(40))
    department_column.create(users)
    department_column = Column('avatar', String(256))
    department_column.create(users)


def downgrade(migrate_engine):
    metadata = MetaData(bind=migrate_engine)
    users = Table('users', metadata, autoload=True)
    users.c['first_name'].drop()
    users.c['last_name'].drop()
    users.c['country'].drop()
    users.c['department'].drop()
    users.c['avatar'].drop()
