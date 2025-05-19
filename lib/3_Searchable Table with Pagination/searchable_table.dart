import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../0_custom_fileds/custom_textfield.dart';
import 'Searchable_table_controller.dart';

class SearchableTable extends StatelessWidget {
  final controller = Get.put(SearchableTableController());

  Widget _highlightMatch(String text, String query) {
    if (query.isEmpty) return Text(text);
    final start = text.toLowerCase().indexOf(query.toLowerCase());
    if (start == -1) return Text(text);
    final end = start + query.length;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, start), style: const TextStyle(color: Colors.black)),
          TextSpan(
              text: text.substring(start, end),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          TextSpan(text: text.substring(end), style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1100;
    final horizontalPadding = isMobile ? 12.0 : 32.0;
    final tableFontSize = isMobile ? 12.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Searchable Paginated Table'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child:
        Obx(() {
          final isSearching = controller.isSearching.value;
          final data = controller.paginatedData;
          final query = controller.query.value;
          final totalMatches = controller.filteredData.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Box
              CustomTextField(
                label: 'Search',
                hintText: 'Search by name or email',
                controller: controller.searchController,
                onChanged: controller.updateQuery,
                suffixIcon: const Icon(Icons.search),
              ),
              const SizedBox(height: 20),

              // Table or Loading or No Match
              Expanded(
                child: isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : totalMatches == 0
                    ? const Center(child: Text('No matches found', style: TextStyle(fontSize: 16)))
                    : SingleChildScrollView(
                  //scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: screenWidth),
                    child: DataTable(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                      columnSpacing: isMobile ? 24 : 48,
                      columns: [
                        DataColumn(
                          label: Text('Name', style: TextStyle(fontSize: tableFontSize)),
                        ),
                        DataColumn(
                          label: Text('Email', style: TextStyle(fontSize: tableFontSize)),
                        ),
                      ],
                      rows: data.map((item) {
                        return DataRow(cells: [
                          DataCell(Row(
                            children: [
                              const Icon(Icons.person, size: 20, color: Colors.teal),
                              const SizedBox(width: 8),
                              _highlightMatch(item['name']!, query),
                            ],
                          )),
                          DataCell(_highlightMatch(item['email']!, query)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Pagination Controls
              if (!isSearching && totalMatches > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: controller.currentPage.value > 0
                          ? controller.previousPage
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: controller.currentPage.value > 0 ? Colors.blue : Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_back, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Previous', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Page ${controller.currentPage.value + 1} '
                          'of ${(totalMatches / controller.rowsPerPage).ceil()}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: (controller.currentPage.value + 1) * controller.rowsPerPage < totalMatches
                          ? controller.nextPage
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: (controller.currentPage.value + 1) * controller.rowsPerPage < totalMatches
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_forward, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Next', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        })
      ),
    );
  }
}
