FROM python:2.7

RUN pip install --no-cache-dir ansible kubernetes flask

ADD . /opt/ansible-coreos
ADD ~/.kube /etc/.kube

ENV PATH="/root/bin:${PATH}"
ENV FLASK_APP=main.py

WORKDIR /opt/ansible-coreos/flask

ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
