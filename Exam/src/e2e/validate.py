import requests
import sys
import json

access_header = sys.argv[1].replace('\n', ' ')
r = requests.get('http://localhost:8000/one_auth/api/validations', headers = { 'Authorization': access_header })
assert r.status_code == 200
data = json.loads(r.text)
message = data['message']
assert message == "Authenticated user"
