from flask import Flask, render_template, request
import datetime
from DatabaseManager import DatabaseManager
from JSONParser import JSONParser
from Measurement import Measurement
import json

app = Flask(__name__)

@app.route('/api/v1.0/check', methods=['GET'])
def check():
    data = {}
    data["status"] = "true"
    return json.dumps(data)

@app.route('/api/v1.0/measurements', methods=['GET'])
def get_measurements():
    measurements = DatabaseManager().getAll()
    data = {}
    data["measurements"] = JSONParser.encodeArray(measurements)
    return json.dumps(data)

@app.route('/api/v1.0/measurementsAfter/<timestamp>', methods=['GET'])
def get_measurementsAfter(timestamp):
    measurements = DatabaseManager().getAllAfter(timestamp)
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
