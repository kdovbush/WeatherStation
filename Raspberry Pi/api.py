from flask import Flask, render_template
import datetime
from DatabaseManager import DatabaseManager
from JSONParser import JSONParser
from Measurement import Measurement
import json

app = Flask(__name__)

tasks = [
	{
		'id': 1,
		'title': u'Create API',
		'description': u'Create API for iOS Application',
		'done': True
	},
	{
		'id': 2,
		'title': u'Create iOS Application',
		'description': u'Need to create Weather Station iOS Application',
		'done': False
	}
]


@app.route('/api/v1.0/weather', methods=['GET'])
def get_measurements():
    measurements = DatabaseManager().getAll()
    data = {}
    data["measurements"] = JSONParser.encodeArray(measurements)
    return json.dumps(data)

@app.route('/api/v1.0/clean', methods=['GET'])
def clean():
    data = {}
    data["status"] = DatabaseManager().clean()
    return json.dumps(data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
