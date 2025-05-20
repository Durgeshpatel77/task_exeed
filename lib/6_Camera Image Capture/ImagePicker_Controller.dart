import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rxn<File> pickedImage = Rxn<File>();

  Future<void> pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
    }
  }

  void submit() {
    if (pickedImage.value != null) {
      Get.snackbar("Success", "Image submitted!");
      // Add your upload logic here

      // Clear the selected image after submission
      pickedImage.value = null;
    } else {
      Get.snackbar("Error", "Please pick or capture an image first.");
    }
  }
}
