#! /usr/bin/env python

import json
from JSONParser import JSONParser

class DetectorsFileParser:

    @staticmethod
    def parseFromFile(fileName):
        with open(fileName) as detectorsFile:
            data = json.load(detectorsFile)
            detectors = data["detectors"]
            return JSONParser.decodeArrayOfDetectors(detectors)


