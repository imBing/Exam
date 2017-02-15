#! /bin/bash

python3 migrations/manage.py version_control postgresql://$DB_USER_NAME:$DB_PASSWORD@$DB_URL/one-auth migrations
python3 migrations/manage.py upgrade --url postgresql://$DB_USER_NAME:$DB_PASSWORD@$DB_URL/one-auth --repository migrations
uwsgi --ini uwsgi.ini
