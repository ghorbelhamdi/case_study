FROM python:3-alpine

RUN mkdir /app

COPY magic_ball.py /app

WORKDIR /app

CMD [ "python", "./magic_ball.py" ]
