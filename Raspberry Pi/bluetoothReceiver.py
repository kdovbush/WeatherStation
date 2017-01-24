#! /usr/bin/env python

import bluetooth
import time
import os
import json

import threading
from threading import Thread

from DatabaseManager import DatabaseManager
from JSONParser import JSONParser
from DetectorsFileParser import DetectorsFileParser

class BluetoothReceiver():
    detectors = []

    # Method receive all data from socket
    def receiveAll(self, socket, size):
        data = ""
        while (len(data) < size):
            packet = socket.recv(size - len(data))
            if not packet:
                return None
            data += packet
        return data
    
    def connect(self, detector):
        try:
            socket = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
            socket.connect((detector.address, detector.port))
            print detector.address + " - Connected"
            self.startReceiving(socket, detector)
        except Exception as e:
            print detector.address + " - Failed to connect"
            print e.args[0]
            print detector.address + " - Reconnecting..."
            time.sleep(5)
            self.connect(detector)
    
    def startReceiving(self, socket, detector):
        data = ""
        while 1:
            try:
                data = self.receiveAll(socket, 71)
                time.sleep(0.5)
            except Exception as e:
                print e.args[0]
                socket.close()
                print detectr.address + " - Socket closed"
                print detectr.address + " - Reconnecting..."
                connect(host, port)
            else:
                print detector.address + " - " + data
                jsonObject = json.loads(data.replace("'", '"'))
                jsonObject["detectorId"] = detector.id
                measurement = JSONParser().decodeMeasurement(jsonObject)
                DatabaseManager().saveMeasurement(measurement)

    def __init__(self):
        #self.detectors = DetectorsFileParser.parseFromFile("Detectors.json")
        #DatabaseManager().saveDetectors(self.detectors)

        for detector in DatabaseManager().getDetectors():
            Thread(target=self.connect, args=[detector]).start()
            #self.connect(detector, agrs=detector)

if __name__ == '__main__':
    BluetoothReceiver()









