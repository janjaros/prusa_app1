FROM python:3.8-slim-buster

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gcc build-essential curl&& \
    rm -rf /var/lib/apt/lists/*


RUN echo "app:x:6666:6666::/home/docker/src:/bin/bash" >> /etc/passwd && addgroup app && addgroup app app
COPY ./requirements.txt /home/docker/src/requirements.txt

RUN pip install -r /home/docker/src/requirements.txt ;

COPY ./src /home/docker/src
COPY docker/app/uwsgi.ini /home/docker/uwsgi.ini
RUN chown -R app:app /home/docker/src
WORKDIR /home/docker/src

CMD ["/usr/local/bin/uwsgi","--socket=0.0.0.0:5000","--protocol=http","--ini=/home/docker/uwsgi.ini" ]



