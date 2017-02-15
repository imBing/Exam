import requests
import sys
import json

email = sys.argv[1]
password = sys.argv[2]
code = sys.argv[3]

r = requests.put('http://localhost:8000/one_auth/api/user',
                 json={'email': email, 'validation_code': code, 'password': password},
                 headers={'Content-Type': 'application/json'})
print(r.status_code)
assert r.status_code == 200

data = json.loads(r.text)
assert len(data['access_token']) == 88
assert data['status'] == 'active'
print(data['access_token'])
