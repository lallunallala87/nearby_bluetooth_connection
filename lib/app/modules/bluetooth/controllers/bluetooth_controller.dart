import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController extends GetxController {
  final Rx<BluetoothAdapterState> adapterState =
      BluetoothAdapterState.unknown.obs;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  final RxBool isScanning = false.obs;

  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeBluetooth();
  }

  @override
  void onClose() {
    _adapterStateSubscription.cancel();
    _scanResultsSubscription.cancel();
    super.onClose();
  }

  void _initializeBluetooth() {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      adapterState.value = state;
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResults.assignAll(results..sort((a, b) => b.rssi.compareTo(a.rssi)));
    });
  }

  Future<void> startScan() async {
    if (adapterState.value != BluetoothAdapterState.on) return;

    isScanning.value = true;
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    isScanning.value = false;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    isScanning.value = false;
  }

  void connectToDevice(BluetoothDevice device) {
    Get.snackbar('Connecting', 'Connecting to ${device.platformName}');
  }
}
