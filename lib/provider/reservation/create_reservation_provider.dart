import 'dart:async';
import 'package:flutterrestaurant/repository/create_reservation_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';

import '../../viewobject/common/ps_value_holder.dart';

class CreateReservationProvider extends PsProvider {
  CreateReservationProvider(
      {@required ReservationRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Reservation Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    reservationListStream =
        StreamController<PsResource<List<Reservation>>>.broadcast();
    subscription = reservationListStream.stream
        .listen((PsResource<List<Reservation>> resource) {
      updateOffset(resource.data.length);

      _reservationList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ReservationRepository _repo;
  PsValueHolder psValueHolder;
  String reservationDate;
  String reservationTime;

  PsResource<ApiStatus> _reservation =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _reservation;

  PsResource<List<Reservation>> _reservationList =
      PsResource<List<Reservation>>(PsStatus.NOACTION, '', <Reservation>[]);

  PsResource<List<Reservation>> get reservationList => _reservationList;
  StreamSubscription<PsResource<List<Reservation>>> subscription;
  StreamController<PsResource<List<Reservation>>> reservationListStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Reservation Provider Dispose: $hashCode');
    super.dispose();
  }

  // Future<dynamic> loadReservationList(String userId) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();
  //   _reservationList = await _repo.getALLReservationList(
  //       reservationListStream,
  //       userId,
  //       limit,
  //       offset,
  //       isConnectedToInternet,
  //       PsStatus.PROGRESS_LOADING);
  // }

  // Future<dynamic> nextReservationList() async {
  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   if (!isLoading && !isReachMaxData) {
  //     super.isLoading = true;
  //     await _repo.getNextPageReservationList(
  //         reservationListStream,
  //         psValueHolder.loginUserId,
  //         limit,
  //         offset,
  //         isConnectedToInternet,
  //         PsStatus.PROGRESS_LOADING);
  //   }
  // }

  Future<dynamic> postReservation(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _reservation = await _repo.postReservation(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _reservation;
  }

  // Future<dynamic> postReservationStatus(
  //   Map<dynamic, dynamic> jsonMap,
  // ) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   _reservationList = await _repo.postReservationStatus(reservationListStream,
  //       jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

  //   return _reservation;
  // }

  // Future<void> resetReservationList() async {
  //   isConnectedToInternet = await Utils.checkInternetConnectivity();
  //   isLoading = true;

  //   updateOffset(0);

  //   _reservationList = await _repo.getALLReservationList(
  //       reservationListStream,
  //       psValueHolder.loginUserId,
  //       limit,
  //       offset,
  //       isConnectedToInternet,
  //       PsStatus.PROGRESS_LOADING);
  //   isLoading = false;
  // }
}
