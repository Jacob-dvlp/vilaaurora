import 'package:flutter/cupertino.dart';
import 'package:flutterrestaurant/viewobject/basket_selected_attribute.dart';
import 'package:flutterrestaurant/viewobject/product.dart';

class BasketIntentHolder {
  const BasketIntentHolder({
    @required this.id,
    @required this.qty,
    @required this.selectedColorId,
    @required this.selectedColorValue,
    @required this.basketPrice,
    @required this.basketSelectedAttributeList,
    @required this.product,
  });
  final String id;
  final String basketPrice;
  final List<BasketSelectedAttribute> basketSelectedAttributeList;
  final String selectedColorId;
  final String selectedColorValue;
  final Product product;
  final String qty;
}
