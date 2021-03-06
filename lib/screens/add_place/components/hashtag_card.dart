import 'package:flutter/material.dart';
import 'package:roadize/constants.dart';
import 'package:roadize/screens/add_place/add_place_screen.dart';
import 'package:roadize/size_config.dart';

class HashTagCard extends StatelessWidget {
  HashTagCard({this.name, this.callback});
  final name;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(13.0),
        vertical: getProportionateScreenHeight(3.0),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              offset: Offset(3, 3),
              color: Colors.black.withOpacity(0.12),
              blurRadius: 3.0),
          BoxShadow(
              offset: Offset(-10, -10),
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10.0)
        ],
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: SizeConfig.fontSize * 0.7,
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: getProportionateScreenWidth(6.0),
          ),
          GestureDetector(
            onTap: () {
              AddPlaceScreenState.hashtag.remove(this);
              this.callback();
            },
            child: Icon(
              Icons.remove_circle,
              size: getProportionateScreenWidth(17.0),
              color: kPrimaryColor.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }
}
