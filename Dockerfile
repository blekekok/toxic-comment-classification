FROM alpine:latest AS unzipper

RUN apk add wget unzip

# RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=10chBXaDiOA6nlH2n17DXMqZ3w-ow3WsD' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=10chBXaDiOA6nlH2n17DXMqZ3w-ow3WsD" -O toxic_comment_model.zip && rm -rf /tmp/cookies.txt

FROM python:3.9

WORKDIR /code

# COPY --from=unzipper /toxic_comment_model.zip /code/toxic_comment_model.zip

# RUN ls -a /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./ /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]