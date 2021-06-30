import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/customized_detail.dart';
import 'package:flutterrestaurant/viewobject/product.dart';

class AttributeDetailIntentHolder {
  const AttributeDetailIntentHolder({
    @required this.product,
    @required this.attributeDetail,
  });
  final Product product;
  final List<CustomizedDetail> attributeDetail;
}
