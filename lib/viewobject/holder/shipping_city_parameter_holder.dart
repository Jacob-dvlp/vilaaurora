import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ShippingCityParameterHolder
    extends PsHolder<ShippingCityParameterHolder> {
  ShippingCityParameterHolder({
    @required this.shopId,
    @required this.countryId,
  });

  final String shopId;
  final String countryId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['shop_id'] = shopId;
    map['country_id'] = countryId;

    return map;
  }

  @override
  ShippingCityParameterHolder fromMap(dynamic dynamicData) {
    return ShippingCityParameterHolder(
      shopId: dynamicData['shop_id'],
      countryId: dynamicData['country_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (shopId != '') {
      key += shopId;
    }
    if (countryId != '') {
      key += countryId;
    }
    return key;
  }
}
