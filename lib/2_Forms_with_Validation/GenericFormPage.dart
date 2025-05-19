import 'package:flutter/material.dart';

class GenericFormPage extends StatefulWidget {
  @override
  _GenericFormPageState createState() => _GenericFormPageState();
}

class _GenericFormPageState extends State<GenericFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields state
  String? _name;
  String? _email;
  String? _selectedOption;
  bool _acceptTerms = false;
  bool _notificationsEnabled = false;
  DateTime? _selectedDate;

  // Dropdown options
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];

  // Date picker method
  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_acceptTerms == false) {
        // Custom validation for checkbox
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must accept the terms')),
        );
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      _formKey.currentState!.save();

      // Show dialog with entered data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Entered Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name: $_name'),
                Text('Email: $_email'),
                Text('Dropdown: $_selectedOption'),
                Text('Accepted Terms: $_acceptTerms'),
                Text('Notifications Enabled: $_notificationsEnabled'),
                Text('Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Or print to console
      // print('Name: $_name, Email: $_email, Option: $_selectedOption, '
      //       'Accepted: $_acceptTerms, Notifications: $_notificationsEnabled, Date: $_selectedDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generic Form with Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name TextField
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Please enter your name' : null,
                onSaved: (val) => _name = val,
              ),
              SizedBox(height: 16),

              // Email TextField
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter your email';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(val)) return 'Enter a valid email';
                  return null;
                },
                onSaved: (val) => _email = val,
              ),
              SizedBox(height: 16),

              // Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select an option'),
                items: _options
                    .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
                validator: (val) =>
                val == null ? 'Please select an option' : null,
                onChanged: (val) {
                  setState(() {
                    _selectedOption = val;
                  });
                },
                value: _selectedOption,
              ),
              SizedBox(height: 16),

              // Checkbox for terms
              CheckboxListTile(
                title: Text('Accept Terms and Conditions'),
                value: _acceptTerms,
                onChanged: (val) {
                  setState(() {
                    _acceptTerms = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 8),

              // Switch for notifications
              SwitchListTile(
                title: Text('Enable Notifications'),
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    _notificationsEnabled = val;
                  });
                },
              ),
              SizedBox(height: 16),

              // Date picker button and display
              Text('Selected Date: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'None'}'),
              ElevatedButton(
                onPressed: () => _pickDate(context),
                child: Text('Pick a Date'),
              ),

              SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
