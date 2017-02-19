from flask import Flask, render_template, request, Response
import datetime
from DatabaseManager import DatabaseManager
from JSONParser import JSONParser
from Measurement import Measurement
import json

app = Flask(__name__)

@app.route('/weatherStation/api/v1.0/checkStatus', methods=['GET'])
def check():
    data = {}
    data["status"] = "true"
    return Response(json.dumps(data), status=200, mimetype="application/json")

@app.route('/weatherStation/api/v1.0/detectors', methods=['GET'])
def getDetectors():
    detectors = DatabaseManager().getDetectors()
    data = {}
    data["detectors"] = JSONParser.encodeArrayOfDetectors(detectors)
    return Response(json.dumps(data), status=200, mimetype="application/json")

@app.route('/weatherStation/api/v1.0/detectors/<int:identifier>/measurements', methods=['GET'])
def getMeasurementsByDetectorId(identifier):
    measurements = DatabaseManager().getMeasurementsForDetectorId(identifier)
    data = {}
    data["measurements"] = JSONParser.encodeArrayOfMeasurements(measurements)
    return Response(json.dumps(data), status=200, mimetype="application/json")

@app.route('/weatherStation/api/v1.0/detectors/<int:identifier>/measurementsAfter/<float:timestamp>', methods=['GET'])
def getMeasurementsByDetectorIdAfter(identifier, timestamp):
    measurements = DatabaseManager().getMeasurementsForDetectorIdAfter(identifier, timestamp)
    data = {}
    data["measurements"] = JSONParser.encodeArrayOfMeasurements(measurements)
    return Response(json.dumps(data), status=200, mimetype="application/json")

@app.route('/weatherStation/api/v1.0/measurements/clean', methods=['GET'])
def clean():
    data = {}
    data["status"] = DatabaseManager().cleanAllMeasurements()
    return Response(json.dumps(data), status=200, mimetype="application/json")

@app.route('/weatherStation/api/v1.0/detectors/<int:identifier>/clean', methods=['GET'])
def cleanDetector(identifier):
    data = {}
    data["status"] = DatabaseManager().cleanMeasurementsForDetectorId(identifier)
    return Response(json.dumps(data), status=200, mimetype="application/json")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
