import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import '../pages/controllers/home_page_controller.dart';
import '../services/player_service.dart';

class RadioInfo extends StatelessWidget {
  final String url;
  final controller = Get.put(
    HomePageController(),
  );

  RadioInfo({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          borderRadius: BorderRadius.circular(15),
          child: FittedBox(
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: _buildUi(context, controller.getRadioByUrl(url)),
              ),
            ),
          )),
    );
  }

  Widget _buildUi(BuildContext context, RadioModel? radio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            radio?.name ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            radio?.description ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w200),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Source: ${radio?.infoSrc ?? ""}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w200),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              radio?.wave ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12, fontWeight: FontWeight.w100),
            ),
          ),
        ),
      ],
    );
  }
}
