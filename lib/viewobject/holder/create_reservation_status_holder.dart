import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ReservationStatusParameterHolder
    extends PsHolder<ReservationStatusParameterHolder> {
  ReservationStatusParameterHolder({
    @required this.userId,
    @required this.reservationId,
    @required this.statusId,
  });

  final String userId;
  final String reservationId;
  final String statusId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['reservation_id'] = reservationId;
    map['status_id'] = statusId;
    return map;
  }

  @override
  ReservationStatusParameterHolder fromMap(dynamic dynamicData) {
    return ReservationStatusParameterHolder(
        userId: dynamicData['user_id'],
        reservationId: dynamicData['reservation_id'],
        statusId: dynamicData['status_id']);
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (reservationId != '') {
      key += reservationId;
    }

    if (statusId != '') {
      key += statusId;
    }

    return key;
  }
}
