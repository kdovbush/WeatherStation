#Working example of retrieving bluetooth data from arduino

import bluetooth
from DatabaseManager import DatabaseManager
import json
from JSONParser import JSONParser
import time
import os

bd_addr = "20:16:02:31:06:40"
port = 1

print("Connecting")
sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
sock.connect((bd_addr, port))


def recvAll(socket, size):
    data = ""
    while (len(data) < size):
        packet = socket.recv(size - len(data))
        if not packet:
            return None
        data += packet
    return data

data = ""

while 1:
    try:
        data = recvAll(sock, 71)
    except Exception as e:
        error = e.args[0]
        print(error)
        print("Socket closed") 
        sock.close()
        break
    else:
        print("TEST" + data)
        jsonObject = json.loads(data.replace("'", '"'))
        measurement = JSONParser().decode(jsonObject)
        DatabaseManager().save(measurement)


