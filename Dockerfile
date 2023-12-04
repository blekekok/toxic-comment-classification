FROM python:3.9

WORKDIR /code

ADD https://www.dropbox.com/scl/fi/i0lnf0f1j8akwma6mhpu0/toxic_comment_model.tar?rlkey=6a7z5tl3pg5fu1qa57umghymx&dl=0 /code

RUN ls /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./ /code

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]