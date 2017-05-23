from flask import Flask
from flask import request
from flask import jsonify

import app

fapp = Flask(__name__)

@fapp.route('/application/<app_name>', methods=['PUT'])
def create_appplication(app_name):
    return jsonify(
        app.create_application(app_name, ** request.json)
    )
