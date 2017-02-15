import os

from flask import Flask

from db.connection import db_engine

APP = Flask(__name__, static_folder='../statics')

if not os.environ.get('ONE_AUTH_ENV'):
    os.environ['ONE_AUTH_ENV'] = 'development'
os.environ['ONE_AUTH_CONFIG_PATH'] = '../config/environments/%s.cfg' % os.environ['ONE_AUTH_ENV']

APP.config.from_envvar('ONE_AUTH_CONFIG_PATH')

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
UPLOAD_FOLDER = '../statics/images'
APP.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

APP.debug = True
APP.db_engine = db_engine(os.environ.get('DB_URL') or APP.config.get('DB_URL'),
                          os.environ.get('DB_USER_NAME') or APP.config.get('DB_USER_NAME'),
                          os.environ.get('DB_PASSWORD') or APP.config.get('DB_PASSWORD'))
