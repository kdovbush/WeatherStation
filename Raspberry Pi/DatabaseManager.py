#! /usr/bin/env python

from datetime import datetime
from Measurement import Measurement
import MySQLdb

class DatabaseManager:
      db = MySQLdb.connect("localhost", "admin","password", "Measurements")
      cursor = db.cursor()
      
      def __init__(self):
            self.db = MySQLdb.connect("localhost", "admin","password", "Measurements")
            self.cursor = self.db.cursor()
            pass


      def save(self, measurement):
            with self.db:
                  time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                  self.cursor.execute("INSERT INTO Measurement (timestamp, temperature, humidity, heatIndex, rainAnalog, rainDigital) VALUES(%s, %s, %s, %s, %s, %s)",
                                      (measurement.createdAt,
                                       measurement.temperature,
                                       measurement.humidity,
                                       measurement.heatIndex,
                                       measurement.rainAnalog,
                                       measurement.rainDigital))

      def getAll(self):
            self.cursor.execute("SELECT timestamp, temperature, humidity, heatIndex, rainAnalog, rainDigital FROM Measurement")

            measurements = []
            for item in self.cursor.fetchall():
                  measurement = Measurement(item[1], item[2], item[4], item[5], item[3], item[0])
                  measurements.append(measurement)
            
            return measurements

      def getAllAfter(self, timestamp):
            self.cursor.execute("SELECT * FROM Measurement WHERE timestamp > %s", (timestamp))
            return self.cursor.fetchall()

      def clean(self):
            try:
                  self.cursor.execute("TRUNCATE TABLE Measurement")
                  return "Success"
            except:
                  return "Failed"
            


      



