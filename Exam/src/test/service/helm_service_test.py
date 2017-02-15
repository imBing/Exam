import unittest
from datetime import datetime
from unittest.mock import patch, MagicMock

import requests
from pip._vendor.requests import Response

from service.helm_service import HelmService


class HelmServiceTest(unittest.TestCase):
    def test_should_return_access_token_from_xml(self):
        access_token_response = '<?xml version="1.0" encoding="UTF-8"?> ' \
                                '<xml>' \
                                '<isOk>True</isOk>' \
                                '<accessToken>gnejX9/Qa+bi52K8Vlm5opGLtuZrdhDlsmvzS</accessToken>' \
                                '<errorInfo></errorInfo>' \
                                '</xml>'
        status, access_token = HelmService.parse_access_token(access_token_response)
        self.assertEquals(status, True)
        self.assertEquals(access_token, 'gnejX9/Qa+bi52K8Vlm5opGLtuZrdhDlsmvzS')

    def test_should_return_false_if_access_token_is_not_exist(self):
        access_token_response = '<?xml version="1.0" encoding="UTF-8"?> ' \
                                '<xml>' \
                                '<errorInfo>asdasd</errorInfo>' \
                                '</xml>'
        status, access_token = HelmService.parse_access_token(access_token_response)
        self.assertEquals(status, False)
        self.assertEquals(access_token, None)

    def test_should_request_HELM_to_get_access_token(self):
        response = MagicMock()
        response.text = "fake_text"
        with patch.object(requests, 'get', return_value=response) as mock_helm_request:
            with patch.object(HelmService, 'parse_access_token', return_value=(True, 'mock_access_token')) as mock_parse:
                access_token = HelmService.get_access_token()
                mock_helm_request.assert_called_with(url='http://53.90.154.29:8080/getToken?dataSource=FeedbackStar')
                mock_parse.assert_called_with('fake_text')
                self.assertEquals('mock_access_token', access_token)

    @classmethod
    def test_should_request_HELM_to_send_email(cls):
        access_token = 'fake_token'
        code = '111111'
        address = 'xx@test.com'
        content = 'Use the following code to finish your registration process: %s' % code
        subject = 'VALIDATION CODE'
        with patch.object(requests, 'post') as mock_helm_request:
            with patch.object(HelmService, 'parse_email_data', return_value='mock_email_data') as mock_parse:
                HelmService.send_email(access_token, content, subject, address)
                mock_parse.assert_called_with(content, subject, address)
                mock_helm_request.assert_called_with(
                    url='http://53.90.154.29:8080/sendEmail',
                    data='mock_email_data',
                    headers={'accessToken': access_token}
                )

    def test_should_should_parse_email_data(self):
        self.maxDiff = None
        code = '111111'
        address = 'xx@test.com'
        content = 'Use the following code to finish your registration process: %s' % code
        subject = 'VALIDATION CODE'
        data = '''<?xml version="1.0" encoding="UTF-8"?>
<xml>
<edmSource>RmVlZGJhY2tTdGFy</edmSource>
<sendEmailRequests>
<uniqueID>MTExMTExMTQ4MzY4ODgxNw==</uniqueID>
<subject>VkFMSURBVElPTiBDT0RF</subject>
<addresses>eHhAdGVzdC5jb20=</addresses>
<templateId></templateId>
<content>VXNlIHRoZSBmb2xsb3dpbmcgY29kZSB0byBmaW5pc2ggeW91ciByZWdpc3RyYXRpb24gcHJvY2VzczogMTExMTEx</content>
<emailFrom>bm8tcmVwbHlAZW1haWwuY29udGFjdC5tZXJjZWRlcy1iZW56LmNvbS5jbg==</emailFrom>
<emailReply>bm8tcmVwbHlAZW1haWwuY29udGFjdC5tZXJjZWRlcy1iZW56LmNvbS5jbg==</emailReply>
<senderName>5qKF6LWb5b635pavLeWllOmpsA==</senderName>
</sendEmailRequests>
</xml>'''
        with patch.object(HelmService, 'parse_unique_id', return_value='1111111483688817'):
            email_data = HelmService.parse_email_data(subject, address, content)
            self.assertEquals(data, email_data)

    def test_should_generate_unique_id_from_code_and_time(self):
        with patch.object(HelmService, 'now_timestamp', return_value=123456):
            unique_id = HelmService.parse_unique_id('Use the following code to finish your registration process:111111')
            self.assertEquals('111111123456', unique_id)

