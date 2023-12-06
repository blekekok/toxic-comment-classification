FROM alpine:latest AS unzipper

RUN apk add wget unzip

RUN wget -O toxic_comment_model.zip https://drive.google.com/uc?id=10chBXaDiOA6nlH2n17DXMqZ3w-ow3WsD

RUN unzip -o toxic_comment_model.zip

FROM python:3.9

WORKDIR /code

COPY --from=unzipper / /code/

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./ /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]