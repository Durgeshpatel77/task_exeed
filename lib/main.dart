import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '2_Forms_with_Validation/GenericFormPage.dart';
import '3_Searchable Table with Pagination/searchable_table.dart';
import '4_Waybill Simulation.dart/Waybill_Screen.dart';
import '5_Barcode Scanning Integration/Barcode_FormPage.dart';
import '5_Barcode Scanning Integration/Barcode_ScannerPage.dart';
import '6_Camera Image Capture/CameraImageCapture_Page.dart';
import '7_Form with Barcode_Image Upload/form_page.dart';
import 'Login_Logout pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
     // home:LoginPage(),//1
     // home: GenericFormPage(),//2
     // home: SearchableTable (),//3
     // home: WaybillScreen (),//4
     // home: BarcodeFormPage(),//5
     // home: CameraImageCapturePage(),//6
      home: FormPage(),  // 7


    );
  }
}
