// BarcodeFormPage.dart
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text("Product Entry"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Scanned Barcode",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _barcodeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "No barcode scanned yet",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _startScan,
                icon: Icon(Icons.qr_code_scanner),
                label: Text("Scan Barcode"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
