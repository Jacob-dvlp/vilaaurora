import 'dart:async';
import 'package:flutterrestaurant/repository/create_reservation_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';

import '../../viewobject/common/ps_value_holder.dart';

class ReservationProvider extends PsProvider {
  ReservationProvider(
      {@required ReservationRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Reservation Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    reservationStream = StreamController<PsResource<Reservation>>.broadcast();
    subscription =
        reservationStream.stream.listen((PsResource<Reservation> resource) {
      //updateOffset(resource.data.length);

      _reservation = resource;

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

  PsResource<Reservation> _reservation =
      PsResource<Reservation>(PsStatus.NOACTION, '', null);

  PsResource<Reservation> get reservation => _reservation;
  StreamSubscription<PsResource<Reservation>> subscription;
  StreamController<PsResource<Reservation>> reservationStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Reservation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postReservationStatus(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _reservation = await _repo.postReservationStatus(reservationStream, jsonMap,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _reservation;
  }
}
