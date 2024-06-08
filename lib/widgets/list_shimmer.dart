import 'package:flutter/material.dart';

class ListShimmer extends StatelessWidget {
  final int itemNum;
  const ListShimmer({super.key, required this.itemNum});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: itemNum,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              top: 6.0,
              right: 8.0,
              bottom: 6.0,
              left: MediaQuery.sizeOf(context).width * 0.0225,
            ),
            child: Row(
              children: [
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 25.0,
                  height: 1.0,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
