#! /usr/bin/env python

# This class contains information about detector of station 
class Detector:
    id = 0
    name = ""
    address = ""

    def __init__(self, name, address, id=None):
        self.id = id
        self.name = name
        self.address = address
