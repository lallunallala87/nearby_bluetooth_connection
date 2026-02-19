import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../controllers/home_controller.dart';
import '../../bluetooth/controllers/bluetooth_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetoothController = Get.put(BluetoothController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        final adapterState = bluetoothController.adapterState.value;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth,
                  size: 100,
                  color: adapterState == BluetoothAdapterState.on
                      ? Colors.blue
                      : Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  adapterState == BluetoothAdapterState.on
                      ? 'Bluetooth is enabled'
                      : 'Bluetooth is disabled',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  adapterState == BluetoothAdapterState.on
                      ? 'Ready to scan for devices'
                      : 'Please enable Bluetooth to continue',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: adapterState == BluetoothAdapterState.on
                      ? () => Get.toNamed('/scan')
                      : () => Get.toNamed('/bluetooth-off'),
                  icon: Icon(
                    adapterState == BluetoothAdapterState.on
                        ? Icons.bluetooth_searching
                        : Icons.bluetooth_disabled,
                  ),
                  label: Text(
                    adapterState == BluetoothAdapterState.on
                        ? 'Scan Devices'
                        : 'Enable Bluetooth',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
