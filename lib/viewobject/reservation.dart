import 'package:flutterrestaurant/viewobject/common/ps_object.dart';
import 'package:flutterrestaurant/viewobject/reservation_status.dart';
import 'package:flutterrestaurant/viewobject/shop_info.dart';
import 'user.dart';

class Reservation extends PsObject<Reservation> {
  Reservation({
    this.id,
    this.resvDate,
    this.resvTime,
    this.note,
    this.shopId,
    this.userId,
    this.userEmail,
    this.userPhoneNo,
    this.userName,
    this.statusId,
    this.addedDate,
    this.addedDateStr,
    this.shopInfo,
    this.reservationstatus,
    this.user,
  });

  String id;
  String resvDate;
  String resvTime;
  String note;
  String shopId;
  String userId;
  String userEmail;
  String userPhoneNo;
  String userName;
  String statusId;
  String addedDate;
  String addedDateStr;
  ShopInfo shopInfo;
  ReservationStatus reservationstatus;
  User user;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Reservation fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Reservation(
        id: dynamicData['id'],
        resvDate: dynamicData['resv_date'],
        resvTime: dynamicData['resv_time'],
        note: dynamicData['note'],
        shopId: dynamicData['shop_id'],
        userId: dynamicData['user_id'],
        userEmail: dynamicData['user_email'],
        userPhoneNo: dynamicData['user_phone_no'],
        userName: dynamicData['user_name'],
        statusId: dynamicData['status_id'],
        addedDate: dynamicData['added_date'],
        addedDateStr: dynamicData['added_date_str'],
        shopInfo: ShopInfo().fromMap(dynamicData['shop']),
        reservationstatus:
            ReservationStatus().fromMap(dynamicData['reservation_status']),
        user: User().fromMap(dynamicData['user']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Reservation object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['resv_date'] = object.resvDate;
      data['resv_time'] = object.resvTime;
      data['note'] = object.note;
      data['shop_id'] = object.shopId;
      data['user_id'] = object.userId;
      data['user_email'] = object.userEmail;
      data['user_phone_no'] = object.userPhoneNo;
      data['user_name'] = object.userName;
      data['status_id'] = object.statusId;
      data['added_date'] = object.addedDate;
      data['added_date_str'] = object.addedDateStr;
      data['shop'] = ShopInfo().toMap(object.shopInfo);
      data['reservation_status'] =
          ReservationStatus().toMap(object.reservationstatus);
      data['user'] = User().toMap(object.user);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Reservation> fromMapList(List<dynamic> dynamicDataList) {
    final List<Reservation> reservationList = <Reservation>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          reservationList.add(fromMap(dynamicData));
        }
      }
    }
    return reservationList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Reservation> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Reservation data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
