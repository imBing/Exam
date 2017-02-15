import requests
import sys
import json

auth_header = sys.argv[1]
r = requests.get('http://localhost:8000/one_auth/api/access_tokens', headers = { 'Authorization': auth_header })
data = json.loads(r.text)
access_token = data['access_token']
assert len(access_token) > 80
print(access_token)
