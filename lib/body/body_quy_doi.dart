import 'package:flutter/material.dart';
import 'package:gia_tien/data/data_vcb.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
  //final TextEditingController _inputController2 = TextEditingController();
  final Logger logger = Logger();
  double calculatedValue = 0.0;
  double calculatedValue2 = 0.0;
  Map<String, Color> sellItemColors = {};
  // Calculate result Widget
  Widget calculatedResult = const Text('');
  Widget calculatedResult2 = const Text('');

  String formatNumber(double number) {
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(number);
  }

  String formatInputValue(String value) {
    final formatter =
        NumberFormat('#,###'); // Format pattern for thousands separator
    // Remove commas and try to parse the double
    String sanitizedValue = value.replaceAll(',', '');
    double? parsedValue = double.tryParse(sanitizedValue);
    if (parsedValue == null) {
      // If input is invalid, return an empty string or the original value
      return value;
    }
    // Format the valid double value
    return formatter.format(parsedValue);
  }

  // Lưu selectedValue vào Hive
  Future<void> saveSelectedValueToLocal(String selectedValue) async {
    try {
      var box = await Hive.openBox('selectedValues');

      // Remove the old selected value
      await box.delete('selectedValue');
      // Save the new selected value
      await box.put('selectedValue', selectedValue);
      logger.d('Selected value: $selectedValue - Saved to local storage');
    } catch (e) {
      logger.e('Error saving selectedValue to local storage');
      // Handle error when saving to local storage
    }
  }

  // Đọc selectedValue từ Hive
  Future<String?> getSelectedValueFromLocal() async {
    try {
      var box = await Hive.openBox('selectedValues');
      return box.get('selectedValue');
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _convertCurrency(bool toVND) async {
    if (_inputController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập số tiền');
      return;
    }

    String? selectedValue = await getSelectedValueFromLocal();
    double inputValue =
        double.tryParse(_inputController.text.replaceAll(',', '')) ?? 0.0;

    if (selectedValue == null || inputValue == 0.0) {
      _showSnackBar('Vui lòng chọn loại tiền bạn muốn');
      return;
    }

    double conversionRate = 1.0;
    for (var item in data2) {
      if (item['Sell'] == selectedValue) {
        conversionRate = double.parse(item['Sell']?.replaceAll(',', '') ?? '0');
        break;
      }
    }

    double resultValue;
    if (toVND) {
      resultValue = inputValue * conversionRate;
    } else {
      resultValue = inputValue / conversionRate;
    }

    String formattedResult = formatNumber(resultValue);
    setState(() {
      if (toVND) {
        calculatedResult = Text(
          'Kết Quả: $formattedResult VND',
          style: const TextStyle(
              color: Color.fromARGB(255, 38, 212, 125),
              fontWeight: FontWeight.bold),
        );
      } else {
        calculatedResult2 = Text(
          'Kết Quả: $formattedResult Ngoại Tệ',
          style: const TextStyle(
              color: Color.fromARGB(255, 38, 212, 125),
              fontWeight: FontWeight.bold),
        );
      }
    });
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

          // ngoai tệ ra việt nam đồng
          SizedBox(
              child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: TextField(
                    controller: _inputController,
                    onChanged: (value) {
                      String formattedValue = formatInputValue(value);
                      if (_inputController.text != formattedValue) {
                        _inputController.value =
                            _inputController.value.copyWith(
                          text: formattedValue,
                          selection: TextSelection.collapsed(
                              offset: formattedValue.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Nhập Số Tiền',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(200, 161, 160, 160))),
                    ),
                  )),
              TextButton(
                onPressed: () => _convertCurrency(true),
                child: const Text('Ngoại Tệ Ra VND'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 148, 148)),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 150, 148, 148)
                              .withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: calculatedResult,
                  ),
                ),
              ),
              //vnd ra ngoại tệ
              TextButton(
                onPressed: () => _convertCurrency(false),
                child: const Text('VND Ra Ngoại Tệ'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 148, 148)),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 150, 148, 148)
                              .withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: calculatedResult2,
                  ),
                ),
              ),
            ],
          )),

          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
