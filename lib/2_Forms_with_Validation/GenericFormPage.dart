import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../0_custom_fileds/custom_textfield.dart';

class GenericFormPage extends StatefulWidget {
  @override
  _GenericFormPageState createState() => _GenericFormPageState();
}

class _GenericFormPageState extends State<GenericFormPage> {
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Form field state variables
  String? _name;
  String? _email;
  String? _selectedOption;
  bool _acceptTerms = false;
  bool _notificationsEnabled = false;
  DateTime? _selectedDate;

  // Dropdown options
  final List<String> _options = ['Ajay', 'Vijay', 'Jay', 'Durgesh', 'Prakash'];

  // Validation error variables
  String? _dateError;
  String? _optionError;

  /// Date picker for selecting a future date
  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateError = null; // Clear previous error
      });
    }
  }

  /// Handles form submission and validation
  void _submit() {
    final isValid = _formKey.currentState!.validate();

    setState(() {
      // Custom validations
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _optionError = _selectedOption == null ? 'Please select an option' : null;
    });

    // Stop submission if validations fail
    if (!isValid || !_acceptTerms || _selectedDate == null || _selectedOption == null) {
      if (!_acceptTerms) {
        // Show error for unchecked terms
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You must accept the terms', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Save form values
    _formKey.currentState!.save();

    // Show dialog with summary
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          bool _isLoading = false;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Entered Data'),
                content: _isLoading
                    ? SizedBox(height: 80, child: Center(child: CircularProgressIndicator()))
                    : SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('Name: $_name'),
                      Text('Email: $_email'),
                      Text('Dropdown: $_selectedOption'),
                      Text('Accepted Terms: $_acceptTerms'),
                      Text('Notifications Enabled: $_notificationsEnabled'),
                      Text('Selected Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}'),
                    ],
                  ),
                ),
                actions: _isLoading
                    ? []
                    : [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);

                      // Simulate delay
                      await Future.delayed(Duration(seconds: 2));

                      // Reset form and UI state
                      _formKey.currentState!.reset();
                      setState(() {
                        _selectedDate = null;
                        _selectedOption = null;
                        _acceptTerms = false;
                        _notificationsEnabled = false;
                        _name = null;
                        _email = null;
                        _dateError = null;
                        _optionError = null;
                      });

                      if (mounted) Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  /// Common decoration for text input fields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }

  /// Main UI builder
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Generic Form'),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 10),

                /// Name Field
                CustomTextField(
                  label: 'Name',
                  controller: _nameController,
                  validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                  onChanged: (val) => _name = val,
                ),
                SizedBox(height: 16),

                /// Email Field
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter your email';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(val)) return 'Enter a valid email';
                    return null;
                  },
                  onChanged: (val) => _email = val,
                ),
                SizedBox(height: 16),

                /// Date Picker Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _dateError != null ? Colors.red : Colors.black87,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => _pickDate(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                                  : 'Select Date',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.black87),
                          ],
                        ),
                      ),
                    ),
                    if (_dateError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12),
                        child: Text(
                          _dateError!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),

                /// Dropdown Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Select an option').copyWith(
                        errorText: null, // Disable default error
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _optionError != null ? Colors.red.shade700 : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _options
                          .map((option) =>
                          DropdownMenuItem(value: option, child: Text(option)))
                          .toList(),
                      validator: (_) => null, // Disable built-in validation
                      onChanged: (val) {
                        setState(() {
                          _selectedOption = val;
                          _optionError = null; // Clear error on selection
                        });
                      },
                      value: _selectedOption,
                    ),
                    if (_optionError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12),
                        child: Text(
                          _optionError!,
                          style: TextStyle(color: Colors.red.shade800, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),

                /// Terms and Conditions Checkbox
                CheckboxListTile(
                  title: Text('Accept Terms and Conditions'),
                  value: _acceptTerms,
                  onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(height: 8),

                /// Notification Switch
                SwitchListTile(
                  title: Text('Enable Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
                SizedBox(height: 32),

                /// Submit Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _submit,
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
