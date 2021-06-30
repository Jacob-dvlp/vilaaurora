import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class UserRegisterParameterHolder
    extends PsHolder<UserRegisterParameterHolder> {
  UserRegisterParameterHolder(
      {@required this.userId,
      @required this.userName,
      @required this.userEmail,
      @required this.userPassword,
      @required this.userPhone,
      @required this.deviceToken,
      @required this.isDeliveryBoy});

  final String userId;
  final String userName;
  final String userEmail;
  final String userPassword;
  final String userPhone;
  final String deviceToken;
  final String isDeliveryBoy;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['user_password'] = userPassword;
    map['user_phone'] = userPhone;
    map['device_token'] = deviceToken;
    map['is_delivery_boy'] = isDeliveryBoy;

    return map;
  }

  @override
  UserRegisterParameterHolder fromMap(dynamic dynamicData) {
    return UserRegisterParameterHolder(
      userId: dynamicData['user_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      userPassword: dynamicData['user_password'],
      userPhone: dynamicData['user_phone'],
      deviceToken: dynamicData['device_token'],
      isDeliveryBoy: dynamicData['is_delivery_boy'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userName != '') {
      key += userName;
    }
    if (userEmail != '') {
      key += userEmail;
    }
    if (userPassword != '') {
      key += userPassword;
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
