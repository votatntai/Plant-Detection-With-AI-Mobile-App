import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/MIAMealModel.dart';

class MIAFavMealComponent extends StatelessWidget {
  MIAMealModel element;

  MIAFavMealComponent({required this.element});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() / 2 - 40,
      child: Column(
        children: [
          Image.asset(element.image, height: 150, width: context.width() / 2 - 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(32),
          8.height,
          Text(element.text, style: primaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis)
        ],
      ),
    ).paddingAll(8);
  }
}
