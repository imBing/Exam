from model.email_request import EmailRequest


class EmailRequestServcie:
    def __init__(self, db_session):
        self.db_session = db_session

    def create_or_update(self, email, validation_code):
        email_request = self.find_by_email(email)
        if email_request is None:
            self.create(email, validation_code)
        else:
            self.update_validation_code(email_request, validation_code)

    def update_validation_code(self, email_request, validation_code):
        email_request.validation_code = validation_code
        self.db_session.commit()

    def create(self, email, validation_code):
        self.db_session.add(EmailRequest(email, validation_code))
        self.db_session.commit()

    def delete(self, email):
        email_request = self.find_by_email(email)
        if email_request is not None:
            self.db_session.delete(email_request)
            self.db_session.commit()

    def find_by_email(self, email):

        return self.db_session.query(EmailRequest).filter_by(email=email).first()
