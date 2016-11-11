#Working example of retrieving bluetooth data from arduino

import bluetooth

bd_addr = "20:16:02:31:06:40"
port = 1

print("Connecting")
sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
sock.connect((bd_addr, port))

data = ""

while 1:
    try:
        data = ""
        #print("Try get data")
        data = sock.recv(4000)
        print(data)
    except:
        print("error")

        print("Socket closed") 
        sock.close()
