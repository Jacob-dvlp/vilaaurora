import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class FBLoginParameterHolder extends PsHolder<FBLoginParameterHolder> {
  FBLoginParameterHolder(
      {@required this.facebookId,
      @required this.userName,
      @required this.userEmail,
      @required this.profilePhotoUrl,
      @required this.deviceToken,
      @required this.profileImgId,
      @required this.isDeliveryBoy});

  final String facebookId;
  final String userName;
  final String userEmail;
  final String profilePhotoUrl;
  final String deviceToken;
  final String isDeliveryBoy;
  final String profileImgId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['facebook_id'] = facebookId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['profile_photo_url'] = profilePhotoUrl;
    map['device_token'] = deviceToken;
    map['profile_img_id'] = profileImgId;
    map['is_delivery_boy'] = isDeliveryBoy;

    return map;
  }

  @override
  FBLoginParameterHolder fromMap(dynamic dynamicData) {
    return FBLoginParameterHolder(
      facebookId: dynamicData['facebook_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      profilePhotoUrl: dynamicData['profile_photo_url'],
      deviceToken: dynamicData['device_token'],
      profileImgId: dynamicData['profile_img_id'],
      isDeliveryBoy: dynamicData['is_delivery_boy'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (facebookId != '') {
      key += facebookId;
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
    if (profileImgId != '') {
      key += profileImgId;
    }
    if (isDeliveryBoy != '') {
      key += isDeliveryBoy;
    }
    return key;
  }
}
