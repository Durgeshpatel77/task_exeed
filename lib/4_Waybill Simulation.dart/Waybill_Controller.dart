import 'package:get/get.dart';

class WaybillController extends GetxController {
  var waybillNumber = ''.obs;
  var isLoading = false.obs;
  var results = <Map<String, String>>[].obs;

  // Dummy data source keyed by waybill number with 30+ entries
  final Map<String, List<Map<String, String>>> mockData = {
    'WB123': List.generate(10, (index) => {
      'id': '${index + 1}',
      'name': 'Package ${String.fromCharCode(65 + index)}',
      'status': index % 3 == 0 ? 'In Transit' : (index % 3 == 1 ? 'Delivered' : 'Pending'),
      'timestamp': '2025-05-19 ${10 + index}:00',
    }),
    'WB456': List.generate(10, (index) => {
      'id': '${index + 11}',
      'name': 'Parcel ${String.fromCharCode(75 + index)}',
      'status': index % 2 == 0 ? 'Pending' : 'Delivered',
      'timestamp': '2025-05-18 ${8 + index}:30',
    }),
    'WB789': List.generate(5, (index) => {
      'id': '${index + 21}',
      'name': 'Box ${index + 1}',
      'status': 'In Transit',
      'timestamp': '2025-05-20 ${9 + index}:45',
    }),
    'WB999': List.generate(5, (index) => {
      'id': '${index + 26}',
      'name': 'Envelope ${index + 1}',
      'status': 'Delivered',
      'timestamp': '2025-05-17 ${7 + index}:15',
    }),
  };

  void fetchWaybillData() async {
    isLoading.value = true;
    results.clear();

    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    if (mockData.containsKey(waybillNumber.value.trim())) {
      results.assignAll(mockData[waybillNumber.value.trim()]!);
    } else {
      results.clear(); // no data found
    }

    isLoading.value = false;
  }
}
