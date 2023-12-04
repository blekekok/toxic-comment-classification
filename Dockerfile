FROM alpine:latest as unzipper

RUN apk add unzip wget curl

RUN curl -o /opt/toxic_comment_model.zip https://www.dropbox.com/scl/fi/cri822iazusc8pl1q6hnp/toxic_comment_model.zip?rlkey=efuhz5o82a13h7szvkgqz4bhj&dl=0 \
    unzip -o /opt/toxic_comment_model.zip

FROM python:3.9

WORKDIR /code

COPY --from=unzipper /opt/ /code/

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./ /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]