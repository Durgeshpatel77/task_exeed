import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ImagePicker_Controller.dart';

class CameraImageCapturePage extends StatelessWidget {
  final ImagePickerController controller = Get.put(ImagePickerController());

  Widget _buildButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Image Capture")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Obx(() {
                  final file = controller.pickedImage.value;
                  if (file == null) {
                    return Text("Select Image From Gallery/Camera.");
                  } else {
                    return Image.file(file);
                  }
                }),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  onTap: controller.pickFromCamera,
                  icon: Icons.camera_alt,
                  label: "Capture Image",
                ),
                _buildButton(
                  onTap: controller.pickFromGallery,
                  icon: Icons.photo_library,
                  label: "Pick from Gallery",
                  color: Colors.deepPurple,
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildSubmitButton(onTap: controller.submit),
          ],
        ),
      ),
    );
  }
}
