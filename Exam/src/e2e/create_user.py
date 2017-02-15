import requests
import sys

email = sys.argv[1]

r = requests.post('http://localhost:8000/one_auth/api/user',
                  json={'email': email},
                  headers={'Content-Type': 'application/json'})
print(r.status_code)
assert r.status_code == 201
