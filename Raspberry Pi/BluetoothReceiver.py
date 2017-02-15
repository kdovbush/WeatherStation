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
            time.sleep(80)
            print detector.address + " - Reconnecting..."
            self.connect(detector)
    
    def startReceiving(self, socket, detector):
        data = ""
        while 1:
            try:
                data = self.receiveAll(socket, 72)
                time.sleep(0.5)
                print detector.address + " - " + data
                jsonObject = json.loads(data.replace("'", '"'))
                jsonObject["detectorId"] = detector.id
                measurement = JSONParser().decodeMeasurement(jsonObject)
                DatabaseManager().saveMeasurement(measurement)
            except Exception as e:
                print e.args[0]
                socket.close()
                print detector.address + " - Socket closed"
                print detector.address + " - Reconnecting..."
                self.connect(detector)

    def __init__(self):
        self.detectors = DetectorsFileParser.parseFromFile("Detectors.json")
        DatabaseManager().saveDetectors(self.detectors)

        for detector in DatabaseManager().getDetectors():
            Thread(target=self.connect, args=[detector]).start()

if __name__ == '__main__':
    BluetoothReceiver()






