#! usr/bin/env python

import json
from Measurement import Measurement

class JSONParser:

      @staticmethod
      def decode(json):
            temperature = json["dallasTemp"]
            humidity = json["dhtHumidity"]
            rainAnalog = json["ylAnalog"]
            rainDigital = json["ylDigital"]
            
            measurement = Measurement(temperature,
                                      humidity,
                                      rainAnalog,
                                      rainDigital)
            return measurement

      @staticmethod
      def decodeArray(json):
            result = []
            for item in json:
                  result.append(JSONParser.decode(item))
            return result

      @staticmethod
      def encode(measurement):
            data = {}
            data["createdAt"] = measurement.createdAt
            data["temperature"] = measurement.temperature
            data["humidity"] = measurement.humidity
            data["heatIndex"] = measurement.heatIndex
            data["rainAnalog"] = measurement.rainAnalog
            data["rainDigital"] = measurement.rainDigital
            return data

      @staticmethod
      def encodeArray(measurements):
            data = []
            for measurement in measurements: 
                  data.append(JSONParser.encode(measurement))

            return data
      
