import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class CouponDiscountParameterHolder
    extends PsHolder<CouponDiscountParameterHolder> {
  CouponDiscountParameterHolder({
    @required this.couponCode,
  });

  final String couponCode;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['coupon_code'] = couponCode;
    return map;
  }

  @override
  CouponDiscountParameterHolder fromMap(dynamic dynamicData) {
    return CouponDiscountParameterHolder(
      couponCode: dynamicData['coupon_code'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (couponCode != '') {
      key += couponCode;
    }

    return key;
  }
}
