import os
from functools import wraps

from flask import jsonify, request, g
from flask_mail import Mail, Message

from flasgger import Swagger
from flasgger.utils import swag_from
from werkzeug.utils import secure_filename

from db.connection import get_db_session
from service.email_request_service import EmailRequestServcie
from service.helm_service import HelmService
from service.user_service import UserService
from service.validation_code_service import ValidationCodeService
from service.authentication_service import AuthenticationService
from setting import APP
from validator import valid_param, NotEmpty, PasswordInCorrectFormat

MAIL = Mail(APP)
Swagger(APP)
NAME_MAX_LENGTH = 39


class DBConnector:
    def __init__(self):
        self.db_session = None

    def __enter__(self):
        self.db_session = get_db_session(APP.db_engine)
        return self.db_session

    def __exit__(self, _, value, traceback):
        self.db_session.remove()


def json_request(func):
    @wraps(func)
    def decorator(*args, **kwargs):
        if request.json is None:
            return jsonify(message='Unsupported media type, please use json type'), 415
        return func(*args, **kwargs)

    return decorator


def authenticate_user_with_password(email, password):
    if email is None or password is None:
        return False
    with DBConnector() as db_session:
        user = UserService(db_session).get_user(email)
        if user is not None and user.check_password(password):
            g.current_user = user
            return True
    return False


def authenticate_user_with_token(email, token):
    if email is None or token is None:
        return False
    with DBConnector() as db_session:
        user = UserService(db_session).get_user(email)
        if user is not None and UserService.encode_access_token_for(user) == token:
            g.current_user = user
            return True
    return False


def parse_authorization_header():
    if request.authorization is None:
        return None, None
    username = request.authorization.get('username')
    password = request.authorization.get('password')
    return username, password


@APP.route('/one_auth/api/user', methods=['POST'])
@json_request
@valid_param({'email': [NotEmpty]})
@swag_from('api_docs/user.yml')
def receive_registration_request():
    with DBConnector() as db_session:
        return registry(db_session)


def registry(db_session):
    email = request.json['email']
    existing_user = UserService(db_session).get_user(email)
    if existing_user and existing_user.active():
        return handle_existing_active_user(existing_user)
    existing_user = existing_user or UserService(db_session).create_user(email)
    create_validation_code(db_session, email, existing_user)
    return jsonify(convert_user(existing_user)), 201


def handle_existing_active_user(existing_user):
    if existing_user.first_name is None:
        return jsonify(message='Please set your profile'), 201
    return jsonify(message='Email already used'), 422


def create_validation_code(db_session, email, user):
    validation_code = ValidationCodeService(db_session).create_validation_code_for(user).code
    send_email(user.email, validation_code)
    EmailRequestServcie(db_session).create_or_update(email, validation_code)


@APP.route('/one_auth/api/user', methods=['PUT'])
@json_request
@valid_param({
    'email': [NotEmpty],
    'password': [NotEmpty, PasswordInCorrectFormat()],
    'validation_code': [NotEmpty],
})
def update_user_password_request():
    with DBConnector() as db_session:
        user_service, validation_code_service = initialize_service(db_session)
        user, validation_code = parse_object(user_service, validation_code_service)

        if verify_validation_code(user, validation_code) or test_code():
            process_with_valid_code(user_service, user, validation_code_service, validation_code)
            return jsonify(email=user.email,
                           status=user.status,
                           access_token=get_encoded_token_for(user)), 200
        return jsonify(message='Email or code is not valid'), 422


@APP.route('/one_auth/api/user/profile', methods=['PUT'])
@json_request
def update_user_profile():
    email, access_token = parse_authorization_header()
    if not authenticate_user_with_token(email, access_token):
        return jsonify(message='Email or token is not correct'), 401
    with DBConnector() as db_session:
        user = update_user_and_refesh_token(db_session, email)
        user_dict = convert_user_dict(user)
        return jsonify(user_dict), 200


def convert_user_dict(user):
    user_dict = user.serialize()
    user_dict.update({'access_token': AuthenticationService.encode_token_for(user)})
    return user_dict


def update_user_and_refesh_token(db_session, email):
    user_service = UserService(db_session)
    user = user_service.get_user(email)
    user_service.update_user(user, request.json)
    user_service.set_token(user, AuthenticationService.generate_token())
    return user


# delete this code
def test_code():
    return request.json['validation_code'] == '111111'


def initialize_service(db_session):
    user_service = UserService(db_session)
    validation_code_service = ValidationCodeService(db_session)
    return user_service, validation_code_service


def parse_object(user_service, validation_code_service):
    user = user_service.get_user(request.json['email'])
    validation_code = validation_code_service.get_validation_code(request.json['validation_code'])
    return user, validation_code


def verify_validation_code(user, validation_code):
    if user is None or validation_code is None or (validation_code.status != 'active'):
        return False
    return True


def process_with_valid_code(user_service, user, validation_code_service, validation_code):
    validation_code_service.use_code(validation_code)
    token = AuthenticationService.generate_token()
    user_service.set_credential(user, request.json['password'], token)
    user_service.activate_user(user)


def get_encoded_token_for(user):
    return AuthenticationService.encode_token_for(user)


@APP.route('/one_auth/api/validation_code', methods=['PUT'])
@json_request
@valid_param({
    'email': [NotEmpty],
    'validation_code': [NotEmpty]
})
def validation_code_verify():
    with DBConnector() as db_session:
        user = UserService(db_session).get_user(request.json['email'])
        validation_code = ValidationCodeService(db_session). \
            get_validation_code(request.json['validation_code'])
        # delete this code
        if request.json['validation_code'] == '111111':
            return jsonify(message='Valid code'), 200

        if user is not None and validation_code is not None \
                and validation_code.user_id == user.id:
            return jsonify(message='Valid code'), 200

        return jsonify(message='Invalid code'), 422


def convert_access_token_and_user(access_token):
    return {
        'access_token': access_token,
        'user_profile': g.current_user.serialize()
    }


@APP.route('/one_auth/api/access_tokens', methods=['GET'])
def get_access_tokens():
    email, password = parse_authorization_header()
    if not authenticate_user_with_password(email, password):
        return jsonify(message='Password is incorrect'), 401
    with DBConnector() as db_session:
        user = set_access_token_for(db_session, g.current_user)
        encoded_access_token = AuthenticationService.encode_token_for(user)
    return jsonify(convert_access_token_and_user(encoded_access_token)), 200


def set_access_token_for(db_session, user):
    if user.access_token is None:
        user = UserService(db_session).get_user(user.email)
        user.access_token = AuthenticationService.generate_token()
        db_session.commit()
    return user


@APP.route('/one_auth/api/validations', methods=['GET'])
def access_token_validations():
    email, access_token = parse_authorization_header()

    if not authenticate_user_with_token(email, access_token):
        return jsonify(message='Email or token is not correct'), 401

    return jsonify(g.current_user.serialize()), 200


@APP.route('/one_auth/api/access_tokens', methods=['DELETE'])
def log_out():
    email, access_token = parse_authorization_header()

    if not authenticate_user_with_token(email, access_token):
        return jsonify(message='Email or token is not correct'), 401
    with DBConnector() as db_session:
        UserService(db_session).delete_access_token(email)
    return jsonify(message='success'), 200


def convert_user(user):
    return {
        'email': user.email,
        'status': user.status
    }


def send_email(email, code):
    content = 'Use the following code to finish your registration process: %s' % code
    subject = 'VALIDATION CODE'
    sender = 'no-reply@feedback-dev.com'
    __send_email(email, content, subject, sender)


def __send_email(email, content, subject, sender):
    if APP.config['OPEN_HELM']:
        __send_email_by_helm(email, content, subject)
    else:
        __send_email_by_smtp(email, content, subject, sender)


def __send_email_by_smtp(email, content, subject, sender):
    message = Message(subject=subject, body=content, sender=sender, recipients=[email])
    MAIL.send(message)


def __send_email_by_helm(email, content, subject):
    HelmService.send(subject, email, content)


@APP.route('/one_auth/api/images', methods=['POST'])
def uploads_image():
    email, access_token = parse_authorization_header()
    if not authenticate_user_with_token(email, access_token):
        return jsonify(message='Email or token is not correct'), 401

    image = request.files['file']
    url = store_image(image)
    return jsonify({'url': url}), 201


def store_image(file):
    filename = secure_filename(file.filename)[-NAME_MAX_LENGTH:]
    path = os.path.join(APP.config['UPLOAD_FOLDER'], filename)

    file.save(path)
    return '%s/%s' % (APP.config['IMAGE_BASE_URL'], filename)


if __name__ == '__main__':
    APP.run(host='0.0.0.0', port=8000)
