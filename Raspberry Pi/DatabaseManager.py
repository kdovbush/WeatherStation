#! /usr/bin/env python

from datetime import datetime
from Measurement import Measurement
from Detector import Detector
import MySQLdb

class DatabaseManager:
      db = MySQLdb.connect("localhost", "kdovbush", "pass", "WeatherStation")
      cursor = db.cursor()
      
      def __init__(self):
            self.db = MySQLdb.connect("localhost", "kdovbush","pass", "WeatherStation")
            self.cursor = self.db.cursor()
            pass

      # --- DETECTORS ---
            
      # Returns list of available detectors
      def getDetectors(self):
            self.cursor.execute("""SELECT id, name, address FROM Detector""")
            detectors = []
            for item in self.cursor.fetchall():
                  detector = Detector(item[1], item[2], item[0])
                  detectors.append(detector)
            
            return detectors

      def saveDetector(self, detector):
            with self.db:
                  self.cursor.execute("""INSERT INTO Detector (name, address) VALUES(%s, %s)""",
                                      (detector.name,
                                       detector.address))


      # --- MEASUREMENTS ---

      # Returns list of measurements for detector
      def getMeasurementsForDetectorId(self, detectorId):
            self.cursor.execute("""SELECT id, createdAt, temperature, humidity, heatIndex, rainAnalog, rainDigital
                                FROM Measurement WHERE detectorId = %s""", (detectorId))

            measurements = []
            for item in self.cursor.fetchall():
                  measurement = Measurement(item[2], item[3], item[5], item[6], detectorId, item[4], item[1], item[0])
                  measurements.append(measurement)
            
            return measurements

      # Returns measurements for detector after passed timestamp
      def getMeasurementsForDetectorIdAfter(self, detectorId, timestamp):
            self.cursor.execute("""SELECT id, createdAt, temperature, humidity, heatIndex, rainAnalog, rainDigital
                                FROM Measurement WHERE detectorId = %s and createdAt > %s""", (detectorId, timestamp))

            measurements = []
            for item in self.cursor.fetchall():
                  measurement = Measurement(item[2], item[3], item[5], item[6], detectorId, item[4], item[1], item[0])
                  measurements.append(measurement)
            
            return measurements

      # Saves passed as parameter measurement
      def saveMeasurement(self, measurement):
            with self.db:
                  time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                  self.cursor.execute("""INSERT INTO Measurement (createdAt, temperature, humidity, heatIndex,
                                      rainAnalog, rainDigital, detectorId) VALUES(%s, %s, %s, %s, %s, %s, %s)""",
                                      (measurement.createdAt,
                                       measurement.temperature,
                                       measurement.humidity,
                                       measurement.heatIndex,
                                       measurement.rainAnalog,
                                       measurement.rainDigital,
                                       measurement.detectorId))

      # Removes all measurements of all detectors
      def cleanAllMeasurements(self):
            try:
                  self.cursor.execute("""TRUNCATE TABLE Measurement""")
                  return "true"
            except:
                  return "false"

      # Removes all measurements for passed detector
      def cleanMeasurementsForDetectorId(self, detectorId):
            try:
                  self.cursor.execute("""DELETE FROM Measurement WHERE detectorId = %s""", (detectorId))
                  return "true"
            except:
                  return "false"
      



