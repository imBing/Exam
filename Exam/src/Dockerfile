FROM python:3.5
MAINTAINER DAIMLER <gqzhao@thoughtworks.com>

RUN apt-get update && apt-get install -y netcat-traditional

RUN mkdir /app
WORKDIR /app
COPY ./requirements.txt /app
RUN pip3 install -r requirements.txt
COPY ./requirements2.txt /app
RUN pip3 install -r requirements2.txt

COPY . /app

EXPOSE 8000

CMD script/run.sh