#! usr/bin/env python

import json
from Measurement import Measurement
from Detector import Detector

class JSONParser:

      # --- DETECTOR ---

      @staticmethod
      def decodeDetector(json):
            name = json["name"]
            address = json["address"]
            port = json["port"]
            detector = Detector(name, address, None, port)
            return detector

      @staticmethod
      def decodeArrayOfDetectors(json):
            detectors = []
            for item in json:
                  detectors.append(JSONParser.decodeDetector(item))
            return detectors

      @staticmethod
      def encodeDetector(detector):
            json = {}
            json["id"] = detector.id
            json["name"] = detector.name
            json["address"] = detector.address
            return json

      @staticmethod
      def encodeArrayOfDetectors(detectors):
            data = []
            for detector in detectors:
                 data.append(JSONParser.encodeDetector(detector))
            return data

      # --- MEASUREMENT ---
      
      @staticmethod
      def decodeMeasurement(json):
            temperature = json["dallasTemp"]
            humidity = json["dhtHumidity"]
            rainAnalog = json["ylAnalog"]
            rainDigital = json["ylDigital"]
            detectorId = json["detectorId"]
            
            measurement = Measurement(temperature,
                                      humidity,
                                      rainAnalog,
                                      rainDigital,
                                      detectorId)
            return measurement

      @staticmethod
      def decodeArrayOfMeasurements(json):
            measurements = []
            for item in json:
                  measurements.append(JSONParser.decodeMeasurement(item))
            return measurements

      @staticmethod
      def encodeMeasurement(measurement):
            data = {}
            data["id"] = measurement.id
            data["createdAt"] = measurement.createdAt if not None else 0.0
            data["temperature"] = measurement.temperature
            data["humidity"] = measurement.humidity
            data["heatIndex"] = measurement.heatIndex
            data["rainAnalog"] = measurement.rainAnalog
            data["rainDigital"] = measurement.rainDigital
            return data

      @staticmethod
      def encodeArrayOfMeasurements(measurements):
            data = []
            for measurement in measurements: 
                  data.append(JSONParser.encodeMeasurement(measurement))

            return data
      
