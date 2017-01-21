#! /usr/bin/env python

from datetime import datetime
from meteocalc import Temp, dew_point, heat_index

class Measurement:
      createdAt = 0.0
      temperature = 27.0
      humidity = 70.0
      heatIndex = 50
      rainAnalog = 800.0
      rainDigital = 1.0

      def __init__(self,
                   temperature,
                   humidity,
                   rainAnalog,
                   rainDigital,
                   heatIndex=0.0,
                   createdAt=None):
            if createdAt is None:
                  self.createdAt = (datetime.now() - datetime(1970, 1, 1)).total_seconds()
            else:
                  self.createdAt = createdAt
            self.temperature = temperature
            self.humidity = humidity
            heatIndex = heat_index(Temp(self.temperature, 'c'), humidity).c
            self.heatIndex = float("%.2f" % round(heatIndex, 2))
            self.rainAnalog = rainAnalog
            self.rainDigital = rainDigital

      def calcHeatIndex(self):
            #convert temperature to Fahrenheit
            T = (self.temperature * 1.8) + 32
            RH = self.humidity
            #Simple formula of Heat index
            HI = 0.5 * (T + 61.0 + (T - 68.0) * 1.2 + RH * 0.094)

            if HI >= 80:
                  c1 = -42.379
                  c2 = 2.04901523
                  c3 = 10.14333127
                  c4 = -0.22475541
                  c5 = -6.83783e-3
                  c6 = -5.481717e-2
                  c7 = 1.22874e-3
                  c8 = 8.5282e-4
                  c9 = -1.99e-6

                  HI = c1 + c2 * T + c3 * RH + c4 * T * RH + c5 * T**2 + c6 * RH**2 + c7 * T**2 * RH + c8 * T * RH**2 + c9 * T**2 * RH**2
            return HI
