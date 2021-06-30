import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class PhoneLoginParameterHolder extends PsHolder<PhoneLoginParameterHolder> {
  PhoneLoginParameterHolder(
      {@required this.phoneId,
      @required this.userName,
      @required this.userPhone,
      @required this.deviceToken,
      @required this.isDeliveryBoy});

  final String phoneId;
  final String userName;
  final String userPhone;
  final String deviceToken;
  final String isDeliveryBoy;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['phone_id'] = phoneId;
    map['user_name'] = userName;
    map['user_phone'] = userPhone;
    map['device_token'] = deviceToken;
    map['is_delivery_boy'] = isDeliveryBoy;

    return map;
  }

  @override
  PhoneLoginParameterHolder fromMap(dynamic dynamicData) {
    return PhoneLoginParameterHolder(
      phoneId: dynamicData['phone_id'],
      userName: dynamicData['user_name'],
      userPhone: dynamicData['user_phone'],
      deviceToken: dynamicData['device_token'],
      isDeliveryBoy: dynamicData['is_delivery_boy'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userName != '') {
      key += userName;
    }
    if (userPhone != '') {
      key += userPhone;
    }

    if (deviceToken != '') {
      key += deviceToken;
    }
    if (isDeliveryBoy != '') {
      key += isDeliveryBoy;
    }
    return key;
  }
}
