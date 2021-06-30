import 'dart:async';
import 'package:flutterrestaurant/db/reservation_dao.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/api/ps_api_service.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';
import '../constant/ps_constants.dart';
import 'Common/ps_repository.dart';

class ReservationRepository extends PsRepository {
  ReservationRepository(
      {@required PsApiService psApiService,
      @required ReservationDao reservationListDao}) {
    _psApiService = psApiService;
    _reservationListDao = reservationListDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ReservationDao _reservationListDao;

  Future<dynamic> insert(Reservation reservationList) async {
    return _reservationListDao.insert(primaryKey, reservationList);
  }

  Future<dynamic> update(Reservation reservationList) async {
    return _reservationListDao.update(reservationList);
  }

  Future<dynamic> delete(Reservation reservationList) async {
    return _reservationListDao.delete(reservationList);
  }

  Future<dynamic> getALLReservationList(
      StreamController<PsResource<List<Reservation>>> reservationListStream,
      String loginUserId,
      int limit,
      int offset,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    reservationListStream.sink
        .add(await _reservationListDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Reservation>> _resource =
          await _psApiService.getReservationList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _reservationListDao.deleteAll();
        await _reservationListDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _reservationListDao.deleteAll();
        }
      }
      reservationListStream.sink.add(await _reservationListDao.getAll());
    }
  }

  Future<dynamic> getNextPageReservationList(
      StreamController<PsResource<List<Reservation>>> reservationListStream,
      String loginUserId,
      int limit,
      int offset,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    reservationListStream.sink
        .add(await _reservationListDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Reservation>> _resource =
          await _psApiService.getReservationList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _reservationListDao.deleteAll();
        }
        await _reservationListDao.insertAll(primaryKey, _resource.data);
      }
      reservationListStream.sink.add(await _reservationListDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postReservation(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postReservation(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<Reservation>> postReservationStatus(
      StreamController<PsResource<Reservation>> reservationListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Reservation> _resource =
        await _psApiService.postReservationStatus(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<Reservation>> completer =
          Completer<PsResource<Reservation>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
