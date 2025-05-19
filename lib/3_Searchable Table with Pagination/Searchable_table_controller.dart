import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchableTableController extends GetxController {
  final RxString query = ''.obs;
  final RxInt currentPage = 0.obs;
  final int rowsPerPage = 10;

  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;

  final List<Map<String, String>> allData = List.generate(30, (index) {
    List<String> domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'mail.com', 'example.com'];
    List<String> names = ['rajesh', 'kamlesh', 'durgesh', 'ajay', 'vishnu', 'jogendra', 'pvendra', 'bhargav'];

    String username = '${names[index % names.length]}';
    String email = '${username}@${domains[index % domains.length]}';
    return {
      'name': username,
      'email': email,
    };
  });

  List<Map<String, String>> get filteredData {
    if (query.value.isEmpty) return allData;
    return allData.where((item) {
      return item['name']!.toLowerCase().contains(query.value.toLowerCase()) ||
          item['email']!.toLowerCase().contains(query.value.toLowerCase());
    }).toList();
  }

  List<Map<String, String>> get paginatedData {
    final data = filteredData;
    final start = currentPage.value * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    return data.sublist(start, end);
  }

  void updateQuery(String value) async {
    isSearching.value = true;
    query.value = value;
    currentPage.value = 0;
    await Future.delayed(Duration(milliseconds: 500)); // simulate delay
    isSearching.value = false;
  }

  void nextPage() {
    if ((currentPage.value + 1) * rowsPerPage < filteredData.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
}
