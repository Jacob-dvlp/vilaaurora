import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: PsColors.categoryBackgroundColor,
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space8, vertical: PsDimens.space12),
          child: Container(
            width: PsDimens.space100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    left: PsDimens.space2, right: PsDimens.space2),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ));
  }
}
