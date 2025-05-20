import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../0_custom_fileds/custom_textfield.dart';
import 'waybill_controller.dart'; // your controller file

class WaybillScreen extends StatelessWidget {
  final controller = Get.put(WaybillController());
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final isSmallScreen = height < 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Waybill Simulation'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // minHeight: height - kToolbarHeight - 3, ///screen height minus appbar and padding
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    label: 'Enter Waybill Number',
                    controller: inputController,
                    hintText: 'e.g. WB789',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        inputController.clear();
                        controller.results.clear();
                      },
                    ),
                    onChanged: (value) => controller.waybillNumber.value = value,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      controller.fetchWaybillData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.results.isEmpty) {
                      return const Text(
                        'No data found for the entered waybill number.',
                      );
                    } else {
                      return Flexible(
                        fit: FlexFit.loose,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 24,
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey.shade200,
                                ),
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Timestamp')),
                                ],
                                rows:
                                    controller.results.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(item['id']!)),
                                          DataCell(Text(item['name']!)),
                                          DataCell(Text(item['status']!)),
                                          DataCell(Text(item['timestamp']!)),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
