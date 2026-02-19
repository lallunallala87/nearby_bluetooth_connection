import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/bluetooth/bindings/bluetooth_binding.dart';
import '../modules/bluetooth/views/bluetooth_off_screen.dart';
import '../modules/bluetooth/views/scan_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BLUETOOTH_OFF,
      page: () => const BluetoothOffScreen(),
      binding: BluetoothBinding(),
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanScreen(),
      binding: BluetoothBinding(),
    ),
  ];
}
