import 'package:flutter/material.dart';
import 'package:gia_tien/board/board_gia_ngoai_te.dart';
import 'package:gia_tien/data/data_vcb.dart';
import 'package:gia_tien/modal/ty_gia_techcom.dart';
import 'package:intl/intl.dart';

class MyTyGia extends StatefulWidget {
  const MyTyGia({super.key});

  @override
  State<MyTyGia> createState() => _MyTyGiaState();
}

class _MyTyGiaState extends State<MyTyGia> with SingleTickerProviderStateMixin {
  final List<bool> _isSelected = [true, false, false];

  List<Map<String, String>> data2 = [];

  @override
  void dispose() {
    // Không cần giải phóng vì không còn AnimationController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchDataVCB().then((data) {
      setState(() {
        data2 = data;
      });
    });
  }

  void _onTap(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = (i == index);
      }
    });
  }

  final List<DataTyGiaTC> item3s = [
    DataTyGiaTC(
        name: "USD", muaVao: '25,800', banRa: '27,000', chuyenKhoan: '29000'),
    DataTyGiaTC(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaTC(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaTC(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaTC(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaTC(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
  ];

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                for (int i = 0; i < _isSelected.length; i++)
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: _isSelected[i]
                          ? const Color.fromARGB(255, 6, 115, 69)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: TextButton(
                      onPressed: () => _onTap(i),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: i == 0
                                  ? 'VietCombank'
                                  : i == 1
                                      ? 'BIDV'
                                      : i == 2
                                          ? 'Techcombank'
                                          : '',
                              style: TextStyle(
                                color: _isSelected[i]
                                    ? Colors.white
                                    : Colors.black, // Màu mặc định
                                fontSize: i == 0 ? 17.0 : 15.0,

                                // Màu khi chọn
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              height: 5,
              width: double.infinity,
              color: const Color.fromARGB(255, 6, 115, 69),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Ngoại Tệ"),
            Text("Mua Vào"),
            Text("Chuyển Khoản"),
            Text("Bán Ra"),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ngày :$formattedDate',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Đơn vị: đ/ngoại tệ'),
            ),
            // Other widgets...
          ],
        ),
        const SizedBox(height: 5),
        if (_isSelected[0])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data2.length,
                    itemBuilder: (context, index) {
                      var item = data2[index];
                      return ListTile(
                        title: Text(
                          '${item['CurrencyName']}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        subtitle: Container(
                          height: 40,
                          color: const Color.fromARGB(255, 235, 238, 240),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(' ${item['Buy']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 5),
                                    child: Text('${item['Transfer']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                        textAlign: TextAlign.center)),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(' ${item['Sell']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        if (_isSelected[1])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: item3s.map((item) => GiaNgoaiTe(item: item)).toList(),
              ),
            ),
          ),
        if (_isSelected[2])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: item3s.map((item) => GiaNgoaiTe(item: item)).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
