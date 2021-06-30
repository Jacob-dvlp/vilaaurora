import 'package:flutterrestaurant/viewobject/reservation.dart';
import 'package:sembast/sembast.dart';

import 'common/ps_dao.dart';

class ReservationDao extends PsDao<Reservation> {
  ReservationDao._() {
    init(Reservation());
  }
  static const String STORE_NAME = 'Reservation';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ReservationDao _singleton = ReservationDao._();

  // Singleton accessor
  static ReservationDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Reservation object) {
    return object.id;
  }

  @override
  Filter getFilter(Reservation object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
