import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_ble_app/ble/homeui.dart';

import 'package:flutter_blue/flutter_blue.dart';

// import 'homeui.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // ignore: non_constant_identifier_names
  String service_uuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  // ignore: non_constant_identifier_names
  String charaCteristic_uuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  Stream<List<int>>? stream;
  late List loadcell;
  double SUM_loadcell = 0;
  double RML_loadcell = 0;
  double RAP_loadcell = 0;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == service_uuid) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == charaCteristic_uuid) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _pop();
    }
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: !isReady
              ? Center(
                  child: Text("Watting"),
                )
              : Container(
                  child: StreamBuilder<List<int>>(
                    stream: stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<int>> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var currentValue = _dataParser(snapshot.data);
                          loadcell = currentValue.split(",");
                          if (loadcell[0] != "nan") {
                            SUM_loadcell = double.parse('${loadcell[0]}');
                          }
                          if (loadcell[1] != "nan") {
                            RML_loadcell = double.parse('${loadcell[1]}');
                          }
                          if(loadcell[2] != "nan"){
                            RAP_loadcell = double.parse('${loadcell[2]}');
                          }
                        }
                      }

                      return HomeUI(
                        sum_data: SUM_loadcell,
                        RML_data: RML_loadcell,
                        RAP_data: RAP_loadcell,
                      );
                    },
                  ),
                )),
    );
    
  }
}
