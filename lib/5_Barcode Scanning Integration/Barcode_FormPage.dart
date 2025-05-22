import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../0_custom_fileds/Custom_BarcodeField.dart';
import 'Barcode_ScannerPage.dart';

class BarcodeFormPage extends StatefulWidget {
  @override
  _BarcodeFormPageState createState() => _BarcodeFormPageState();
}

class _BarcodeFormPageState extends State<BarcodeFormPage> {
  final TextEditingController _barcodeController = TextEditingController();

  void _startScan() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
    );

    if (scannedValue != null) {
      setState(() {
        _barcodeController.text = scannedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Entry"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CustomBarcodeField(
              controller: _barcodeController,
              onScanTap: _startScan,  // Scan callback
            )
          ],
        ),
      ),
    );
  }
}
