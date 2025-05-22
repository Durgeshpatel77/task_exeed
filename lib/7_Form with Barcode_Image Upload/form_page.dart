import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_exeed/5_Barcode%20Scanning%20Integration/Barcode_ScannerPage.dart';

// Controller for handling form data and logic
class FormController extends GetxController {
  // Text controllers for name and barcode input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();

  // Observable string to hold barcode value
  final RxString barcode = ''.obs;

  // Observable nullable File for picked image (camera/gallery)
  final Rxn<File> imageFile = Rxn<File>();

  // ImagePicker instance to pick images from camera or gallery
  final ImagePicker _picker = ImagePicker();

  // Method to open barcode scanner page and receive scanned barcode result
  Future<void> scanBarcode(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BarcodeScannerPage()),
    );
    if (result != null) {
      barcode.value = result;
      barcodeController.text = result; // Update barcode text field with scanned value
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) imageFile.value = File(picked.path);
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) imageFile.value = File(picked.path);
  }

  // Submit handler - validate inputs and show confirmation dialog
  void submit() {
    Get.dialog(
      AlertDialog(
        title: Text("Submitted Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Name: ${nameController.text}"),
            SizedBox(height: 8),
            Text("Barcode: ${barcode.value}"),
            SizedBox(height: 8),
            imageFile.value != null
                ? Image.file(imageFile.value!, height: 150)
                : Text("No image selected"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              // Clear form fields for new input
              nameController.clear();
              barcode.value = '';
              barcodeController.clear();
              imageFile.value = null;
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }
}

// UI page for the form
class FormPage extends StatelessWidget {
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    // Get screen size once
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Form Page"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barcode TextField
              TextField(
                controller: controller.barcodeController,
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

              // Scan Barcode Button
              Center(
                child: GestureDetector(
                  onTap: () => controller.scanBarcode(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
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
              ),
              SizedBox(height: 16),

              // Image Picker & Display
              Obx(() => Column(
                children: [
                  controller.imageFile.value != null
                      ? Image.file(controller.imageFile.value!, height: 500, width: double.infinity)
                      : Text("No image selected"),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: controller.pickImageFromCamera,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Camera",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: controller.pickImageFromGallery,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_library, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Gallery",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              SizedBox(height: size.height*0.05),

              // Submit Button
              InkWell(
                onTap: controller.submit,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
