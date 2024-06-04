import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

Future<List<Map<String, String>>> fetchDataVCB() async {
  var response = await http.get(Uri.parse(
      'https://portal.vietcombank.com.vn/Usercontrols/TVPortal.TyGia/pXML.aspx'));

  if (response.statusCode == 200) {
    var document = xml.XmlDocument.parse(response.body);
    var exrateList = document.findAllElements('Exrate');

    List<Map<String, String>> data2 = []; // Create an empty list to store data

    for (var exrate in exrateList) {
      var currencyCode = exrate.attributes
          .firstWhere((attr) => attr.name.local == 'CurrencyCode',
              orElse: () => throw Exception('Missing CurrencyCode attribute'))
          .value;
      var currencyName = exrate.attributes
          .firstWhere((attr) => attr.name.local == 'CurrencyName',
              orElse: () => throw Exception('Missing Buy attribute'))
          .value;
      var buy = exrate.attributes
          .firstWhere((attr) => attr.name.local == 'Buy',
              orElse: () => throw Exception('Missing Buy attribute'))
          .value;
      var transfer = exrate.attributes
          .firstWhere((attr) => attr.name.local == 'Transfer',
              orElse: () => throw Exception('Missing Transfer attribute'))
          .value;
      var sell = exrate.attributes
          .firstWhere((attr) => attr.name.local == 'Sell',
              orElse: () => throw Exception('Missing Sell attribute'))
          .value;

      data2.add({
        'CurrencyCode': currencyCode,
        'CurrencyName': currencyName,
        'Buy': buy,
        'Transfer': transfer,
        'Sell': sell,
      });
    }

    // Now explicitly return the populated data2 list
    return data2;
  } else {
    // Handle unsuccessful response (optional)
    throw Exception('Failed to fetch exchange rates');
  }
}
