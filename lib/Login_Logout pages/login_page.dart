import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../0_custom_fileds/custom_textfield.dart';
import 'package:task_exeed/Login_Logout pages/login_controller.dart';

class LoginPage extends StatelessWidget {
  // Initialize and register LoginController with GetX dependency injection
  final LoginController authController = Get.put(LoginController());

  // Reactive bool to toggle password visibility
  final RxBool isPasswordVisible = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the login screen
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.black)), // Black title text
        centerTitle: true,
        backgroundColor: Colors.white, // Match background color with scaffold
        elevation: 0, // No shadow on the app bar
        iconTheme: IconThemeData(color: Colors.black), // Icon color for back button or others
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24), // Padding around the login form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make children take full width
            children: [
              // Lock icon at the top for visual indication
              Icon(Icons.lock_outline, size: 80, color: Colors.black87),
              SizedBox(height: 24), // Spacing after icon

              // Email input field using custom reusable widget
              CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => authController.email.value = val, controller: passwordController,
              ),
              SizedBox(height: 16),

              // Password input field with reactive visibility toggle
              Obx(() => CustomTextField(
                label: 'Password',
                obscureText: !isPasswordVisible.value, // Hide/show password
                onChanged: (val) => authController.password.value = val,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey[800],
                  ),
                  onPressed: () {
                    // Toggle password visibility when icon pressed
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ), controller: emailController,
              )),
              SizedBox(height: 16),

              // Show error message reactively if login fails or inputs invalid
              Obx(() => Text(
                authController.error.value,
                style: TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              )),
              SizedBox(height: 24),

              // Login button that disables and shows loader while login is in progress
              Obx(() => ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null // Disable button when loading
                    : () => authController.login(), // Trigger login method
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: authController.isLoading.value
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
