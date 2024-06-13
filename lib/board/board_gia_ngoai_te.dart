import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GiaNgoaiTe extends StatelessWidget {
  GiaNgoaiTe({
    super.key,
    required this.item,
  });
  // ignore: prefer_typing_uninitialized_variables
  var item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 235, 238, 240),
      ),
      height: 20,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(item.name),
          Text(item.muaVao),
          Text(item.chuyenKhoan),
          Text(item.banRa),
        ],
      ),
    );
  }
}
