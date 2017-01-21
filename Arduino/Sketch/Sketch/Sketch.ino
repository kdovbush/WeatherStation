#include <Arduino.h>
#include <SPI.h>

// Bluetooth
#include <SoftwareSerial.h>
// Dallas temperature
#include <OneWire.h>
#include <DallasTemperature.h>
// DHT sensor
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

// Used pins
//#define RED_LED_PIN         8
//#define GREEN_LED_PIN       9

#define DALLAS_SENSOR_PIN   10

#define DHT_SENSOR_PIN      3         // Pin which is connected to the DHT sensor.

#define YL_DIGITAL_PIN      2
#define YL_ANALOG_PIN       A7

#define DHT_TYPE            DHT11     // DHT 11

// NOTE: Use BT(1,0) is old board.
SoftwareSerial BT(0,1); // RX, TX
// Dallas temperature
OneWire oneWire(DALLAS_SENSOR_PIN);   // Setup a oneWire instance to communicate with any OneWire devices
DallasTemperature sensors(&oneWire);  // Pass our oneWire reference to Dallas Temperature.
// DHT
DHT_Unified dht(DHT_SENSOR_PIN, DHT_TYPE);

// Loop delay
uint32_t delayMS = 60000;             // 1 minute

void setup()
{
    BT.begin(9600);
    setupDallasDevice();
    setupDHTDevice();

    pinMode(YL_DIGITAL_PIN, INPUT);

    pinMode(9, OUTPUT);
  }

void loop()
{
  char printBuffer[80];

  char dallasTempBuffer[50];
  char dhtHumidityBuffer[50];

  char ylPrecipitationAnalogBuffer[10];
  char ylPrecipitationDigitalBuffer[10];

  dtostrf(getDallasTemperature(), 3+3, 3, dallasTempBuffer);
  dtostrf(getDHTHumidity(), 3, 0, dhtHumidityBuffer);

  dtostrf(analogRead(YL_ANALOG_PIN), 4, 0, ylPrecipitationAnalogBuffer);
  dtostrf(digitalRead(YL_DIGITAL_PIN), 1, 0, ylPrecipitationDigitalBuffer);

  sprintf(printBuffer, "{\"dallasTemp\":%s,\"dhtHumidity\":%s,\"ylAnalog\":%s,\"ylDigital\":%s}", dallasTempBuffer, dhtHumidityBuffer, ylPrecipitationAnalogBuffer, ylPrecipitationDigitalBuffer);
  BT.println(printBuffer);

  digitalWrite(9, LOW);
  delay(1000);
  digitalWrite(9, HIGH);

  delay(delayMS);
}


void setupDallasDevice() {
    // locate devices on the bus
    //sensors.begin();
    // set the resolution to 9 bit (Each Dallas/Maxim device is capable of several different resolutions)
    //sensors.setResolution(insideThermometer, 9);
}

// function to print the temperature for a device
float getDallasTemperature()
{
    sensors.requestTemperatures(); // Send the command to get temperatures

    float tempC = sensors.getTempCByIndex(0);
    return tempC;
    //Serial.println(DallasTemperature::toFahrenheit(tempC)); // Converts tempC to Fahrenheit
}



void setupDHTDevice() {
    // Initialize device.
    dht.begin();

    sensor_t sensor;
    // Set delay between sensor readings based on sensor details.
    //delayMS = sensor.min_delay / 1000;
}

float getDHTTemperature() {
  sensors_event_t event;
  dht.temperature().getEvent(&event);
  if (isnan(event.temperature)) {
    Serial.println("Error reading temperature!");
    return 0.0;
  }
  return event.temperature;
}

float getDHTHumidity() {
    // Get temperature event and print its value.
    sensors_event_t event;

    // Get humidity event and print its value.
    dht.humidity().getEvent(&event);
    if (isnan(event.relative_humidity)) {
        Serial.println("Error reading humidity!");
        return 0;
    }
    return event.relative_humidity;
}

// DHT Sensor
// See guide for details on sensor wiring and usage:
//   https://learn.adafruit.com/dht/overview

// Depends on the following Arduino libraries:
// - Adafruit Unified Sensor Library: https://github.com/adafruit/Adafruit_Sensor
// - DHT Sensor Library: https://github.com/adafruit/DHT-sensor-library
