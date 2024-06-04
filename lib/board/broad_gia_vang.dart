import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GiaVang extends StatelessWidget {
  GiaVang({super.key, required this.item});
  // ignore: prefer_typing_uninitialized_variables
  var item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.amber,
      ),
      height: 60,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Center(child: Text(item.muaVao))),
            SizedBox(child: Center(child: Text(item.banRa))),
          ],
        ),
      ),
    );
  }
}
