import requests
import sys

email = sys.argv[1]
code = sys.argv[2]

r = requests.put('http://localhost:8000/one_auth/api/validation_code',
                 json={'email': email, "validation_code": code},
                 headers={'Content-Type': 'application/json'})
assert r.status_code == 200
