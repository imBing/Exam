import base64
from datetime import datetime
from xml.etree import ElementTree as ET

import requests


class HelmService(object):
    @classmethod
    def parse_access_token(cls, access_token_response):
        access_token = ET.fromstring(access_token_response).find('accessToken')
        status = False
        if access_token is not None:
            access_token = access_token.text
            status = True
        return status, access_token

    @classmethod
    def get_access_token(cls):
        response = requests.get(url='http://53.90.154.29:8080/getToken?dataSource=FeedbackStar')
        status, access_token = cls.parse_access_token(response.text)
        if status:
            return access_token
        else:
            return None

    @classmethod
    def parse_email_data(cls, subject, address, content):
        code = base64.standard_b64encode(cls.parse_unique_id(content).encode('utf-8'))
        content = base64.standard_b64encode(content.encode('utf-8'))
        subject = base64.standard_b64encode(subject.encode('utf-8'))
        address = base64.standard_b64encode(address.encode('utf-8'))
        email_data = '''<?xml version="1.0" encoding="UTF-8"?>
<xml>
<edmSource>RmVlZGJhY2tTdGFy</edmSource>
<sendEmailRequests>
<uniqueID>{}</uniqueID>
<subject>{}</subject>
<addresses>{}</addresses>
<templateId></templateId>
<content>{}</content>
<emailFrom>bm8tcmVwbHlAZW1haWwuY29udGFjdC5tZXJjZWRlcy1iZW56LmNvbS5jbg==</emailFrom>
<emailReply>bm8tcmVwbHlAZW1haWwuY29udGFjdC5tZXJjZWRlcy1iZW56LmNvbS5jbg==</emailReply>
<senderName>5qKF6LWb5b635pavLeWllOmpsA==</senderName>
</sendEmailRequests>
</xml>'''
        return email_data.format(
            code.decode('utf-8'),
            subject.decode('utf-8'),
            address.decode('utf-8'),
            content.decode('utf-8')
        )

    @classmethod
    def send_email(cls, access_token, subject, address, content):
        email_data = cls.parse_email_data(subject, address, content)
        requests.post(
            url='http://53.90.154.29:8080/sendEmail',
            data=email_data,
            headers={'accessToken': access_token}
        )

    @classmethod
    def send(cls, subject, email, content):
        access_token = cls.get_access_token()
        cls.send_email(access_token, subject, email, content)

    @classmethod
    def parse_unique_id(cls, content):
        code = HelmService.parse_validation_code(content)
        unique_id = HelmService.now_timestamp()
        return code + str(int(unique_id))

    @classmethod
    def parse_validation_code(cls, content):
        return content[-6:]

    @classmethod
    def now_timestamp(cls):
        return datetime.now().timestamp()
