import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_exeed/Login_Logout pages/login_controller.dart';

class HomePage extends StatelessWidget {
  // Access the existing LoginController instance using Get.find()
  final LoginController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and logout button
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          // Logout button in app bar
          IconButton(
            onPressed: () {
              // Show confirmation dialog before logging out
              Get.defaultDialog(
                title: "Logout",
                titleStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
                middleText: "Are you sure you want to logout?",
                middleTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                radius: 16, // Rounded corners of the dialog
                backgroundColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                confirmTextColor: Colors.white,
                cancelTextColor: Colors.black87,
                barrierDismissible: false, // Disable tap outside to dismiss dialog
                // Custom content widget inside the dialog
                content: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content vertically
                  children: [
                    // Logout icon for visual cue
                    Icon(
                      Icons.logout_rounded,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 12),
                    // Additional message text inside the dialog
                    Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    // Row with Cancel and Confirm buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button - closes dialog without logging out
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        // Confirm button - calls logout and closes dialog
                        ElevatedButton(
                          onPressed: () {
                            authController.logout(); // Perform logout logic
                            Get.back(); // Close dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            elevation: 5, // Add shadow for better visual depth
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout, color: Colors.black87), // Logout icon color
          )
        ],
      ),
      // Body content - simple welcome text centered
      body: Center(
        child: Text("Welcome to the Home Page!"),
      ),
    );
  }
}
