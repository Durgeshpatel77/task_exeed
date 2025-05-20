import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Let's keep icon size as 80% of screen width or max 400 for large screens
    final iconSize = screenWidth * 0.8 > 400 ? 400.0 : screenWidth * 0.8;

    return Scaffold(
      // appBar: AppBar(title: Text("Scan Barcode")),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final String? value = barcode.rawValue;
              if (value != null) {
                controller.stop();
                Navigator.pop(context, value);
              }
            },
          ),
          Center(
            child: Icon(
              Icons.crop_free_sharp,
              size: iconSize,
              color: Colors.white.withOpacity(0.5), // lighter color to appear thinner
            ),
          ),
        ],
      ),
    );
  }
}
