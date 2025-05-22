  import 'package:flutter/material.dart';

  class CustomBarcodeField extends StatelessWidget {
    final TextEditingController controller;
    final VoidCallback onScanTap;

    const CustomBarcodeField({
      Key? key,
      required this.controller,
      required this.onScanTap,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: "No barcode scanned yet",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
          SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: onScanTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // so it wraps content
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Scan Barcode',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
  }
