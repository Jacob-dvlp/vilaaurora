import 'package:flutterrestaurant/viewobject/common/ps_object.dart';

class ReservationStatus extends PsObject<ReservationStatus> {
  ReservationStatus({this.id, this.title, this.userFlag});

  String id;
  String title;
  String userFlag;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ReservationStatus fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ReservationStatus(
        id: dynamicData['id'],
        title: dynamicData['title'],
        userFlag: dynamicData['user_flag'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data['id'] = object.id;
      data['title'] = object.title;
      data['user_flag'] = object.userFlag;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<ReservationStatus> fromMapList(List<dynamic> dynamicDataList) {
    final List<ReservationStatus> defaultPhotoList = <ReservationStatus>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          defaultPhotoList.add(fromMap(dynamicData));
        }
      }
    }
    return defaultPhotoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ReservationStatus> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (ReservationStatus data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
