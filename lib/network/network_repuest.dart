import 'dart:convert';
import 'package:gia_tien/model/data_bidv.dart';
import 'package:http/http.dart' as http;

Future<List<DataBIDV>> fetchData() async {
  final headers = {
    'User-Agent': 'Mozilla/5.0 ( compatible ) ',
    'Accept': '*/*',
  };
  final response = await http.get(
      Uri.parse('https://dongabank.com.vn/exchange/export'),
      headers: headers);
  if (response.statusCode == 200) {
    final jsonString = response.body.substring(1, response.body.length - 1);
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> items = data['items'];

    final List<DataBIDV> bidvData = items
        .map((item) => DataBIDV.fromJson(item as Map<String, dynamic>))
        .toList();

    return bidvData;
  } else {
    throw Exception('Failed to load data');
  }
}
