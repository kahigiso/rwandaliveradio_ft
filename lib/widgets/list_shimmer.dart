import 'package:flutter/material.dart';

class ListShimmer extends StatelessWidget {
  final int itemNum;
  const ListShimmer({super.key, required this.itemNum});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemNum,
        itemBuilder: (context, index) {
          if(index == 0 ){
            return Container(
              color: Colors.transparent,
              alignment: Alignment.bottomLeft,
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).height * 0.125,
              margin: const EdgeInsets.only(left: 14,bottom: 25, right: 18),
              child: Container(color: Colors.grey.withOpacity(0.6), width: MediaQuery.sizeOf(context).width * 0.55, height: 30,),
            );
          }
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
                  width: MediaQuery.sizeOf(context).width * 0.82,
                  height: MediaQuery.sizeOf(context).height * 0.120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
