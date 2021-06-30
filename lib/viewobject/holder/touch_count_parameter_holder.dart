import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class TouchCountParameterHolder extends PsHolder<TouchCountParameterHolder> {
  TouchCountParameterHolder(
      {@required this.typeId, @required this.typeName, @required this.userId});

  final String typeId;
  final String typeName;
  final String userId;
  

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['type_id'] = typeId;
    map['type_name'] = typeName;
    map['user_id'] = userId;

    return map;
  }

  @override
  TouchCountParameterHolder fromMap(dynamic dynamicData) {
    return TouchCountParameterHolder(
      typeId: dynamicData['type_id'],
      typeName: dynamicData['type_name'],
      userId: dynamicData['user_id'],
     
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (typeId != '') {
      key += typeId;
    }
    if (typeName != '') {
      key += typeName;
    }

    if (userId != '') {
      key += userId;
    }
    return key;
  }
}
