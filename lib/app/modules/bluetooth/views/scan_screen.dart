import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/bluetooth_controller.dart';

class ScanScreen extends GetView<BluetoothController> {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan for Devices'),
        backgroundColor: Colors.blue,
        actions: [
          Obx(
            () => controller.isScanning.value
                ? IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: controller.stopScan,
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.startScan,
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.adapterState.value != BluetoothAdapterState.on) {
          return const Center(child: Text('Bluetooth is not enabled'));
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Devices',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => controller.isScanning.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.startScan,
                            child: const Text('Scan'),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.scanResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_searching,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No devices found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Make sure Bluetooth is enabled and devices are in range',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        if (!controller.isScanning.value)
                          ElevatedButton(
                            onPressed: controller.startScan,
                            child: const Text('Scan Again'),
                          ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.scanResults.length,
                    itemBuilder: (context, index) {
                      final result = controller.scanResults[index];
                      final device = result.device;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          onTap: () async {
                            List<BluetoothService> arrService =
                                device.servicesList;
                            for (BluetoothService bleService in arrService) {
                              if (bleService.serviceUuid.toString() == "") {
                                List<BluetoothCharacteristic> arrChar =
                                    bleService.characteristics;

                                for (BluetoothCharacteristic bleChar
                                    in arrChar) {
                                  print("Characteristic UUID: ${bleChar.uuid}");

                                  if (bleChar.properties.read) {
                                    List<int> value = await bleChar.read();
                                    print("Read value: $value");
                                  }

                                  if (bleChar.properties.notify) {
                                    await bleChar.setNotifyValue(true);
                                    bleChar.value.listen((value) {
                                      print("Notification value: $value");
                                    });
                                  }

                                  List<BluetoothDescriptor> arrDesc =
                                       bleChar.descriptors;

                                  for (BluetoothDescriptor bleDesc in arrDesc) {
                                    print("Descriptor UUID: ${bleDesc.uuid}");

                                    List<int> descValue = await bleDesc.read();
                                    print("Descriptor value: $descValue");
                                  }
                                }
                              }
                            }
                          },
                          leading: const Icon(
                            Icons.bluetooth,
                            color: Colors.blue,
                          ),
                          title: Text(
                            device.platformName.isNotEmpty
                                ? device.platformName
                                : 'Unknown Device',
                          ),
                          subtitle: Text(device.remoteId.str),
                          trailing: Text('${result.rssi} dBm'),
                          //onTap: () => controller.connectToDevice(device),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(
        () => controller.isScanning.value
            ? FloatingActionButton(
                onPressed: controller.stopScan,
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              )
            : FloatingActionButton(
                onPressed: controller.startScan,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.bluetooth_searching),
              ),
      ),
    );
  }
}
