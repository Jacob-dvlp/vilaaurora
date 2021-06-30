import 'dart:async';
import 'package:flutterrestaurant/repository/shipping_area_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/viewobject/shipping_area.dart';

class ShippingAreaProvider extends PsProvider {
  ShippingAreaProvider(
      {@required ShippingAreaRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    //isDispose = false;
    print('ShippingArea Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shippingAreaListStream =
        StreamController<PsResource<List<ShippingArea>>>.broadcast();
    subscription = shippingAreaListStream.stream
        .listen((PsResource<List<ShippingArea>> resource) {
      updateOffset(resource.data.length);

      _shippingAreaList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ShippingArea>>> shippingAreaListStream;
  ShippingAreaRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ShippingArea>> _shippingAreaList =
      PsResource<List<ShippingArea>>(PsStatus.NOACTION, '', <ShippingArea>[]);

  PsResource<List<ShippingArea>> get shippingAreaList => _shippingAreaList;
  StreamSubscription<PsResource<List<ShippingArea>>> subscription;

  final PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('ShippingArea Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getShippingAreaById(String shippingId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await _repo.getShippingById(
        isConnectedToInternet, shippingId, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadShippingAreaList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getAllShippingAreaList(shippingAreaListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShippingAreaList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShippingAreaList(shippingAreaListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShippingAreaList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingAreaList(shippingAreaListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
