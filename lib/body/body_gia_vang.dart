import 'package:flutter/material.dart';
import 'package:gia_tien/data/data_vcb.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MyGiaVang extends StatefulWidget {
  const MyGiaVang({super.key});

  @override
  State<MyGiaVang> createState() => _MyGiaVangState();
}

class _MyGiaVangState extends State<MyGiaVang>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> data2 = [];
  bool isLoading = false; // Flag to indicate data fetching state
  String errorMessage = ''; // String to store error message, if any
  bool _isExpandedValue2 = false; // State for first button
  bool _isExpandedValue3 = false; // State for second button
  String? selectedValueToShow;
  String? selectedValueToShowValue3;

  final TextEditingController _inputController =
      TextEditingController(); // Input controller for the text field
  final Logger logger = Logger();
  double calculatedValue = 0.0;
  Map<String, Color> sellItemColorsValue2 = {};
  Map<String, Color> sellItemColorsValue3 = {};
  Widget calculatedResult = const Text('');

  String formatNumber(double number) {
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(number);
  }

  Future<void> saveSelectedValueToLocal(String selectedValue) async {
    try {
      var box = await Hive.openBox('selectedValues');
      await box
          .delete('selectedValue2'); // Xóa giá trị cũ trong 'selectedValue2'
      await box.put('selectedValue2',
          selectedValue); // Lưu giá trị mới vào 'selectedValue2'
      logger.d(
          'Selected value: $selectedValue - Saved to local storage as selectedValue2');
    } catch (e) {
      logger.e('Error saving selectedValue2 to local storage');
    }
  }

  Future<void> saveSelectedValueToLocalValue3(String selectedValue) async {
    try {
      var box = await Hive.openBox('selectedValues');
      await box
          .delete('selectedValue3'); // Xóa giá trị cũ trong 'selectedValue3'
      await box.put('selectedValue3',
          selectedValue); // Lưu giá trị mới vào 'selectedValue3'
      logger.d(
          'Selected value: $selectedValue - Saved to local storage as selectedValue3');
    } catch (e) {
      logger.e('Error saving selectedValue3 to local storage');
    }
  }

  Future<Map<String, String?>> getSelectedValuesFromLocal() async {
    try {
      var box = await Hive.openBox('selectedValues');
      String? value2 =
          box.get('selectedValue2'); // Đọc giá trị từ 'selectedValue2'
      String? value3 =
          box.get('selectedValue3'); // Đọc giá trị từ 'selectedValue3'
      return {'value2': value2, 'value3': value3};
    } catch (e) {
      logger.e('Error retrieving selectedValues from local storage');
      return {'value2': null, 'value3': null};
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

    var selectedValues = await getSelectedValuesFromLocal();
    String? value2 = selectedValues['value2'];
    String? value3 = selectedValues['value3'];
    double inputValue =
        double.tryParse(_inputController.text.replaceAll(',', '')) ?? 0.0;

    if (value2 == null || value3 == null || inputValue == 0.0) {
      _showSnackBar('Vui lòng chọn loại tiền bạn muốn');
      return;
    }

    double rate2 = 1.0;
    double rate3 = 1.0;
    for (var item in data2) {
      if (item['Sell'] == value2) {
        rate2 = double.parse(item['Sell']?.replaceAll(',', '') ?? '0');
      }
      if (item['Sell'] == value3) {
        rate3 = double.parse(item['Sell']?.replaceAll(',', '') ?? '0');
      }
    }

    double resultValue = inputValue * (rate2 / rate3);
    String formattedResult = formatNumber(resultValue);

    setState(() {
      if (toVND) {
        calculatedResult = Text(
          'Result: $formattedResult',
          style: const TextStyle(
              color: Color.fromARGB(255, 38, 212, 125),
              fontWeight: FontWeight.bold),
        );
      }
    });
  }

  Widget _buildValueSelectionList(bool isValue2) {
    Map<String, Color> sellItemColors =
        isValue2 ? sellItemColorsValue2 : sellItemColorsValue3;

    return Visibility(
      visible:
          (isValue2 && _isExpandedValue2) || (!isValue2 && _isExpandedValue3),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Text(errorMessage)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data2.length,
                  itemBuilder: (context, index) {
                    var item = data2[index];
                    Color sellColor = sellItemColors[item['Sell'] ?? ''] ??
                        const Color.fromARGB(255, 238, 236, 236);

                    return ListTile(
                      subtitle: InkWell(
                        onTap: () {
                          sellItemColors.clear();
                          SharedPreferences.getInstance().then((prefs) {
                            if (isValue2) {
                              prefs.remove(
                                  'selectedValue2'); // clear previous value2
                            } else {
                              prefs.remove(
                                  'selectedValue3'); // clear previous value3
                            }
                          });
                          setState(() {
                            sellItemColors[item['Sell'] ?? ''] = Colors.blue;
                            if (isValue2) {
                              selectedValueToShow = item[
                                  'CurrencyCode']; // Set CurrencyCode for value 2
                            } else {
                              selectedValueToShowValue3 = item[
                                  'CurrencyCode']; // Set CurrencyCode for value 3
                            }
                          });

                          String selectedValue = item['Sell'] ?? 'N/A';
                          if (isValue2) {
                            saveSelectedValueToLocal(
                                selectedValue); // Save to value2
                          } else {
                            saveSelectedValueToLocalValue3(
                                selectedValue); // Save to value3
                          }
                        },
                        child: Container(
                          height: 40,
                          color: sellColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text('${item['CurrencyCode']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(' ${item['Sell']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // bảng tra ảnh
  Map<String, Image> imageLookupTable = {
    'AUD': Image.asset('assets/images/AUD.png'),
    'CAD': Image.asset('assets/images/CAD.png'),
    'CHF': Image.asset('assets/images/CHF.png'),
    'CNY': Image.asset('assets/images/CNY.png'),
    'DKK': Image.asset('assets/images/DKK.png'),
    'EUR': Image.asset('assets/images/EUR.png'),
    'GBP': Image.asset('assets/images/GBP.png'),
    'HKD': Image.asset('assets/images/HKD.png'),
    'INR': Image.asset('assets/images/INR.png'),
    'JPY': Image.asset('assets/images/JPY.png'),
    'KRW': Image.asset('assets/images/KRW.png'),
    'KWD': Image.asset('assets/images/KWD.png'),
    'MYR': Image.asset('assets/images/MYR.png'),
    'NOK': Image.asset('assets/images/NOK.png'),
    'RUB': Image.asset('assets/images/RUB.png'),
    'SAR': Image.asset('assets/images/SAR.png'),
    'SEK': Image.asset('assets/images/SEK.png'),
    'SGD': Image.asset('assets/images/SGD.png'),
    'THB': Image.asset('assets/images/THB.png'),
    'USD': Image.asset('assets/images/USD.png'),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isExpandedValue2 = !_isExpandedValue2;
                // Ensure only one list is expanded at a time
                if (_isExpandedValue2) _isExpandedValue3 = false;
              });
            },
            child: Text(
              _isExpandedValue2
                  ? 'Return'
                  : (selectedValueToShow != null &&
                          selectedValueToShow!.isNotEmpty)
                      ? selectedValueToShow!
                      : 'USD',
            ),
          ),

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:
                      imageLookupTable[selectedValueToShow ?? 'USD']?.image ??
                          const AssetImage('assets/images/USD.png'),
                )),
          ),

          _buildValueSelectionList(true), // List for Value 2

          Container(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  hintText: 'input number money',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(200, 161, 160, 160))),
                ),
              )),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _isExpandedValue3 = !_isExpandedValue3;
                // Ensure only one list is expanded at a time
                if (_isExpandedValue3) _isExpandedValue2 = false;
              });
            },
            child: Text(
              _isExpandedValue3
                  ? 'Return'
                  : (selectedValueToShowValue3 != null &&
                          selectedValueToShowValue3!.isNotEmpty)
                      ? selectedValueToShowValue3!
                      : 'AUD',
            ),
          ),

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageLookupTable[selectedValueToShowValue3 ?? 'AUD']
                          ?.image ??
                      const AssetImage('assets/images/AUD.png'),
                )),
          ),

          _buildValueSelectionList(false), // List for Value 3

          SizedBox(
            child: Column(
              children: [
                TextButton(
                  onPressed: () => _convertCurrency(true),
                  child: const Text('Exchange'),
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
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
