import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home_page.dart';
import 'login_page.dart';

class LoginController extends GetxController {
  // Observable variables to track email and password inputs
  final email = ''.obs;
  final password = ''.obs;

  // Observable variable to hold error messages for the login form
  var error = ''.obs;

  // Observable flag to indicate loading state during login process
  var isLoading = false.obs;

  // Dummy credentials for login validation (replace with real authentication later)
  final dummyEmail = "admin@example.com";
  final dummyPassword = "admin123";

  // Method to handle login logic asynchronously
  Future<void> login() async {
    // Set loading to true to show loading indicator in UI
    isLoading.value = true;

    // Simulate network or processing delay (e.g., API call)
    await Future.delayed(Duration(seconds: 1));

    // Validate input fields and credentials
    if (email.value.isEmpty || password.value.isEmpty) {
      error.value = 'Please enter email and password';
    }
    else if (email.value != dummyEmail && password.value != dummyPassword) {
      error.value = 'Both email and password are incorrect';
    }
    else if (email.value != dummyEmail) {
      error.value = 'Email is incorrect';
    }
    else if (password.value != dummyPassword) {
      error.value = 'Password is incorrect';
    }
    else {
      // Clear any existing error
      error.value = '';

      // Save login status in SharedPreferences to persist user session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigate to the home page and remove all previous routes
      Get.offAll(() => HomePage());
    }

    // Reset loading state after login process completes
    isLoading.value = false;
  }

  // Method to handle user logout
  Future<void> logout() async {
    // Access SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear login status on logout
    await prefs.setBool('isLoggedIn', false);

    // Navigate to login page and remove all previous routes
    Get.offAll(() => LoginPage());
  }
}
