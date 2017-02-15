from sqlalchemy import MetaData
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import scoped_session, sessionmaker

METADATA = MetaData()
BASE = declarative_base(metadata=METADATA)


def get_db_session(engine):
    return scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))


def db_engine(url, user_name, password):
    return create_engine(('postgresql://%s:%s@%s/one-auth' % (user_name,
                                                              password,
                                                              url)),
                         encoding="utf8",
                         echo=True)
