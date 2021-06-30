import 'package:flutter/cupertino.dart';
import 'package:flutterrestaurant/viewobject/common/ps_holder.dart';

class AppleLoginParameterHolder extends PsHolder<AppleLoginParameterHolder> {
  AppleLoginParameterHolder(
      {@required this.appleId,
      @required this.userName,
      @required this.userEmail,
      @required this.profilePhotoUrl,
      @required this.deviceToken,
      @required this.isDeliveryBoy});

  final String appleId;
  final String userName;
  final String userEmail;
  final String profilePhotoUrl;
  final String deviceToken;
  final String isDeliveryBoy;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['apple_id'] = appleId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['profile_photo_url'] = profilePhotoUrl;
    map['device_token'] = deviceToken;
    map['is_delivery_boy'] = isDeliveryBoy;

    return map;
  }

  @override
  AppleLoginParameterHolder fromMap(dynamic dynamicData) {
    return AppleLoginParameterHolder(
      appleId: dynamicData['apple_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      profilePhotoUrl: dynamicData['profile_photo_url'],
      deviceToken: dynamicData['device_token'],
      isDeliveryBoy: dynamicData['is_delivery_boy'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (appleId != '') {
      key += appleId;
    }
    if (userName != '') {
      key += userName;
    }
    if (userEmail != '') {
      key += userEmail;
    }

    if (profilePhotoUrl != '') {
      key += profilePhotoUrl;
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
