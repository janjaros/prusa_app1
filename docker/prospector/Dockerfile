ARG IMAGE
FROM $IMAGE

RUN pip install prospector

COPY docker/prospector/configs /home/docker/cfg

CMD /usr/local/bin/prospector --profile /home/docker/cfg/prospector.yaml

