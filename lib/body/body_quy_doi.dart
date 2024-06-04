import 'package:flutter/material.dart';
import 'package:gia_tien/data/data_vcb.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQuyDoi extends StatefulWidget {
  const MyQuyDoi({super.key});

  @override
  State<MyQuyDoi> createState() => _MyQuyDoiState();
}

class _MyQuyDoiState extends State<MyQuyDoi>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> data2 = [];
  bool isLoading = false; // Flag to indicate data fetching state
  String errorMessage = ''; // String to store error message, if any
  bool _isExpanded = false;
  String? selectedValueToShow;

  final TextEditingController _inputController =
      TextEditingController(); // Input controller for the text field
  final Logger logger = Logger();
  double calculatedValue = 0.0;
  Map<String, Color> sellItemColors = {};

  Future<void> saveSelectedValueToLocal(String selectedValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedValue', selectedValue);
      logger.d('Selected value: $selectedValue - Saved to local storage');
    } catch (e) {
      logger.e('Error saving selectedValue to local storage');
      // Handle error when saving to local storage
    }
  }

  Future<String?> getSelectedValueFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('selectedValue');
    } catch (e) {
      logger.e('Error retrieving selectedValue from local storage');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call the data fetching function
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true
      errorMessage = ''; // Clear any previous error message
    });

    try {
      final data = await fetchDataVCB();
      if (mounted) {
        setState(() {
          data2 = data;
          isLoading =
              false; // Set loading state to false after successful fetch
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false; // Set loading state to false after error
          errorMessage = 'Error fetching data: $error'; // Store error message
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? 'Trở Lại' : 'Chọn Loại Tiền'),
          ),
          Visibility(
            visible: _isExpanded,
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Display loading indicator if data is being fetched
                : errorMessage.isNotEmpty
                    ? Text(
                        errorMessage) // Display error message if there's an error
                    : ListView.builder(
                        shrinkWrap:
                            true, // Prevent excessive scrolling if data is limited
                        itemCount: data2.length,
                        itemBuilder: (context, index) {
                          var item = data2[index];
                          Color sellColor =
                              sellItemColors[item['Sell'] ?? ''] ??
                                  const Color.fromARGB(255, 238, 236, 236);

                          return ListTile(
                              subtitle: InkWell(
                            onTap: () {
                              sellItemColors.clear();
                              //String selectedItemValue = item['Sell'] ?? 'N/A';
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.remove('selectedValue');
                              });
                              setState(() {
                                sellItemColors[item['Sell'] ?? ''] =
                                    Colors.blue;
                              });

                              String selectedValue = item['Sell'] ?? 'N/A';
                              saveSelectedValueToLocal(selectedValue);
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text('Selected value: $selectedValue'),
                                ));
                              }
                            },
                            child: Container(
                                height: 40,
                                color: sellColor,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  10), // 5 units of padding on both sides
                                          child: Text('${item['CurrencyCode']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(' ${item['Sell']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ])),
                          ));
                        },
                      ),
          ),
          SizedBox(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Nhập Số Tiền',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(200, 161, 160, 160)))),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    String? selectedValue = await getSelectedValueFromLocal();
                    double inputValue =
                        double.tryParse(_inputController.text) ?? 0.0;
                    if (selectedValue == null || inputValue == 0.0) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please select a currency and enter a valid amount.'),
                        ),
                      );
                      return;
                    }
                    double conversionRate = 1.0;
                    for (var item in data2) {
                      if (item['Sell'] == selectedValue) {
                        conversionRate = double.parse(item['Buy']
                                ?.replaceAll(',', '') ??
                            '0'); // Assuming 'Buy' field holds the conversion rate
                        break;
                      }
                    }
                    double calculatedValue = inputValue * conversionRate;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Converted value: $calculatedValue ${selectedValue.replaceFirst(RegExp(r'[^\w]'), '')}'),
                      ),
                    );
                  },
                  child: const Text('Đổi Tiền')),
            ],
          )),
        ],
      ),
    );
  }
}
