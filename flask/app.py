import yaml
import glob

from flask import render_template
from kubernetes import client, config

config.load_kube_config("/etc/.kube/config")


def create_namespace(resource):
    v1 = client.CoreV1Api()
    namespaces = v1.list_namespace()
    if resource.metadata.name not in namespaces:
        return v1.create_namespace(resource)


def create_application(app_name, ** data):
    template_path = '/opt/ansible-coreos/applications/'+app_name+'/*.yml'

    for file in glob.glob(template_path):
        resource = render_resource(file, ** data)
        if resource.kind == "Namespace":
            create_namespace(resource)


def render_resource(file, ** data):
    content = render_template(file, **data)
    resource = yaml.load(content)
    return resource
