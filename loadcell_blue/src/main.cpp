 #include <Arduino.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <HX711_ADC.h>

// pins:
#define DT1 13
#define sck1 14

#define DT2 18
#define sck2 19

#define DT3 26
#define sck3 25

#define DT4 22
#define sck4 23

// double calibrationValue = -50.0F; // calibration value (see example file "Calibration.ino")uncomment this if you want to set the calibration value in the sketch
float calibrationValue1 = -24.39;
float calibrationValue2 = -27.90;
float calibrationValue3 = -27.75;
float calibrationValue4 = -27.19;
unsigned long t = 0;
unsigned long stabilizingtime = 400;

double sensorReading1;
double sensorReading2;
double sensorReading3;
double sensorReading4;
double sum;
double RML;
double RAP;

HX711_ADC LoadCell1(DT1, sck1);
HX711_ADC LoadCell2(DT2, sck2);
HX711_ADC LoadCell3(DT3, sck3);
HX711_ADC LoadCell4(DT4, sck4);

BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *pServer)
    {
        deviceConnected = true;
        BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer *pServer)
    {
        deviceConnected = false;
    }
};

void getData()
{
    sensorReading1 = LoadCell1.getData();
    sensorReading2 = LoadCell2.getData();
    sensorReading3 = LoadCell3.getData();
    sensorReading4 = LoadCell4.getData();

    if (sensorReading1 < 0)
    {
        sensorReading1 = 0.00;
    }
    if (sensorReading2 < 0)
    {
        sensorReading2 = 0.00;
    }
    if (sensorReading3 < 0)
    {
        sensorReading3 = 0.00;
    }
    if (sensorReading4 < 0)
    {
        sensorReading4 = 0.00;
    }

    double mass1 = (sensorReading1 / 1000.0);
    double mass2 = (sensorReading2 / 1000.0);
    double mass3 = (sensorReading3 / 1000.0);
    double mass4 = (sensorReading4 / 1000.0);

    sum = (mass1 + mass2 + mass3 + mass4);
    RML = ((mass2 + mass4) / (sum));
    RAP = ((mass3 + mass4) / (sum));


    Serial.print("Load_cell output val 1: ");
    Serial.print(mass1, 2);
    Serial.println(" Kg");

    Serial.print("Load_cell output val 2: ");
    Serial.print(mass2, 2);
    Serial.println(" Kg");

    Serial.print("Load_cell output val 3: ");
    Serial.print(mass3, 2);
    Serial.println(" Kg");

    Serial.print("Load_cell output val 4: ");
    Serial.print(mass4, 2);
    Serial.println(" Kg");


}

void setup()
{
    Serial.begin(115200);
    Serial.println("Starting...");
    LoadCell1.begin();
    LoadCell2.begin();
    LoadCell3.begin();
    LoadCell4.begin();

    LoadCell1.start(stabilizingtime);
    LoadCell2.start(stabilizingtime);
    LoadCell3.start(stabilizingtime);
    LoadCell4.start(stabilizingtime);

    if (LoadCell1.getTareTimeoutFlag() && LoadCell2.getTareTimeoutFlag() && LoadCell3.getTareTimeoutFlag() & LoadCell4.getTareTimeoutFlag())
    {
        Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
        while (1)
            ;
    }
    else
    {
        LoadCell1.setCalFactor(calibrationValue1);
        LoadCell2.setCalFactor(calibrationValue2);
        LoadCell3.setCalFactor(calibrationValue3);
        LoadCell4.setCalFactor(calibrationValue4);

        // Create the BLE Device
        BLEDevice::init("sitting app");

        // Create the BLE Server
        pServer = BLEDevice::createServer();
        pServer->setCallbacks(new MyServerCallbacks());

        // Create the BLE Service
        BLEService *pService = pServer->createService(SERVICE_UUID);

        // Create a BLE Characteristic
        pCharacteristic = pService->createCharacteristic(
            CHARACTERISTIC_UUID,
            BLECharacteristic::PROPERTY_READ |
                BLECharacteristic::PROPERTY_WRITE |
                BLECharacteristic::PROPERTY_NOTIFY |
                BLECharacteristic::PROPERTY_INDICATE);

        // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
        // Create a BLE Descriptor
        pCharacteristic->addDescriptor(new BLE2902());

        // Start the service
        pService->start();

        // Start advertising
        BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
        pAdvertising->addServiceUUID(SERVICE_UUID);
        pAdvertising->setScanResponse(false);
        pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
        BLEDevice::startAdvertising();
        Serial.println("START......");
        Serial.println("Waiting a client connection to notify...");
    }
}

void loop()
{

    static boolean newDataReady = 0;
    const int serialPrintInterval = 0; // increase value to slow down serial print activity
    if (LoadCell1.update() && LoadCell2.update() && LoadCell3.update() && LoadCell4.update())
        newDataReady = true;

    if (newDataReady)
    {
        if (millis() > t + serialPrintInterval)
        {
  
            if (deviceConnected)
            {

                getData();
                String data = "";
                data += sum;
                data += ",";
                data += RML;
                data += ",";
                data += RAP;

                pCharacteristic->setValue((char *)data.c_str());
                pCharacteristic->notify();

                Serial.print("sum: ");
                Serial.print(sum, 2);
                Serial.println(" Kg");

                Serial.print("R ML: ");
                Serial.print(RML, 2);
                Serial.println(" Kg");

                Serial.print("R AP: ");
                Serial.print(RAP, 2);
                Serial.println(" Kg");
                delay(500);
                newDataReady = 0;
                t = millis();
            }
        }
    }

    // disconnecting Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
    if (!deviceConnected && oldDeviceConnected)
    {
        delay(500);                  // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected)
    {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }
}


// #include <HX711_ADC.h>

// // pins:
// #define DT1 13
// #define sck1 14

// #define DT2 18
// #define sck2 19

// #define DT3 26
// #define sck3 25

// #define DT4 22
// #define sck4 23


// float calibrationValue1 = -24.39;// calibration value (see example file "Calibration.ino")uncomment this if you want to set the calibration value in the sketch
// float calibrationValue2 = -27.90;
// float calibrationValue3 = -27.75;
// float calibrationValue4 = -27.19;
// unsigned long t = 0;
// unsigned long stabilizingtime = 400;



// float sensorReading1;
// float sensorReading2;
// float sensorReading3;
// float sensorReading4;

// HX711_ADC LoadCell1(DT1, sck1);
// HX711_ADC LoadCell2(DT2, sck2);
// HX711_ADC LoadCell3(DT3, sck3);
// HX711_ADC LoadCell4(DT4, sck4);

// void getData(float *data)
// {
//   float mass1 = LoadCell1.getData();
//   float mass2 = LoadCell2.getData();
//   float mass3 = LoadCell3.getData();
//   float mass4 = LoadCell4.getData();
//   if(mass1 < 0){
//     mass1 = 0.00;
//   }
//   if(mass2 < 0){
//     mass2= 0.00;
//   }
//   if(mass3 < 0){
//     mass3= 0.00;
//   }
//   if(mass4 < 0){
//     mass4= 0.00;
//   }
//   sensorReading1 = (mass1 / 1000.0);
//   sensorReading2 = (mass2 / 1000.0);
//   sensorReading3 = (mass3 / 1000.0);
//   sensorReading4 = (mass4 / 1000.0);



//   data[0] = sensorReading1;
//   data[1] = sensorReading2;
//   data[2] = sensorReading3;
//   data[3] = sensorReading4;

//   Serial.print("Load_cell output val 1: ");
//   Serial.print(data[0], 2);
//   Serial.println(" Kg");
//   Serial.print("Load_cell output val 2: ");
//   Serial.print(data[1], 2);
//   Serial.println(" Kg");
//   Serial.print("Load_cell output val 3: ");
//   Serial.print(data[2], 2);
//   Serial.println(" Kg");
//   Serial.print("Load_cell output val 4: ");
//   Serial.print(data[3], 2);
//   Serial.println(" Kg");
//   Serial.println();

// }



// void setup()
// {
//   Serial.begin(115200);
//   Serial.println("Starting...");
//   LoadCell1.begin();
//   LoadCell2.begin();
//   LoadCell3.begin();
//   LoadCell4.begin();

//   LoadCell1.start(stabilizingtime);
//   LoadCell2.start(stabilizingtime);
//   LoadCell3.start(stabilizingtime);
//   LoadCell4.start(stabilizingtime);

//   if (LoadCell1.getTareTimeoutFlag() && LoadCell2.getTareTimeoutFlag() && LoadCell3.getTareTimeoutFlag() && LoadCell4.getTareTimeoutFlag())
//   {
//     Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
//     while (1);

//   }

//   else
//   {
//     LoadCell1.setCalFactor(calibrationValue1);
//     LoadCell2.setCalFactor(calibrationValue2);
//     LoadCell3.setCalFactor(calibrationValue3);
//     LoadCell4.setCalFactor(calibrationValue4);
//     Serial.println("Startup is complete");
//   }

// }

// void loop()
// {
//   static boolean newDataReady = 0;
//   const int serialPrintInterval = 0; // increase value to slow down serial print activity
//   if (LoadCell1.update() && LoadCell2.update() && LoadCell3.update() && LoadCell4.update())
//     newDataReady = true;

//   if (newDataReady)
//   {
//     if (millis() > t + serialPrintInterval)
//     {
//       float sensorData[4];;
//       getData(sensorData);
//       delay(1000);
//       newDataReady = 0;
//       t = millis();
//     }
//   }
// }