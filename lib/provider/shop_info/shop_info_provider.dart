import 'dart:async';
import 'package:flutterrestaurant/repository/shop_info_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';

class ShopInfoProvider extends PsProvider {
  ShopInfoProvider(
      {@required ShopInfoRepository repo,
      @required this.psValueHolder,
      @required this.ownerCode,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShopInfo Provider: $hashCode ($ownerCode) ');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shopInfoListStream = StreamController<PsResource<ShopInfo>>.broadcast();
    subscription =
        shopInfoListStream.stream.listen((PsResource<ShopInfo> resource) async {
      _shopInfo = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        // Update to share preference
        // To submit tax and shipping tax to transaction

        if (_shopInfo != null && shopInfo.data != null) {
         await replaceShopInfoValueHolderData(
            _shopInfo.data.overallTaxLabel,
            _shopInfo.data.overallTaxValue,
            _shopInfo.data.shippingTaxLabel,
            _shopInfo.data.shippingTaxValue,
            _shopInfo.data.shippingId,
            _shopInfo.data.id,
            _shopInfo.data.messenger,
            _shopInfo.data.whapsappNo,
            _shopInfo.data.aboutPhone1,
            _shopInfo.data.minimumOrderAmount,
          );

         await replaceCheckoutEnable(
              _shopInfo.data.paypalEnabled,
              _shopInfo.data.stripeEnabled,
              _shopInfo.data.paystackEnabled,
              _shopInfo.data.codEmail,
              _shopInfo.data.banktransferEnabled,
              _shopInfo.data.standardShippingEnable,
              _shopInfo.data.zoneShippingEnable,
              _shopInfo.data.noShippingEnable);
          
        await  replacePublishKey(_shopInfo.data.stripePublishableKey);

         await replacePayStackKey(_shopInfo.data.paystackKey);

          notifyListeners();
        }
      }
    });
  }

  ShopInfoRepository _repo;
  PsValueHolder psValueHolder;
  String ownerCode;

  PsResource<ShopInfo> _shopInfo =
      PsResource<ShopInfo>(PsStatus.NOACTION, '', null);

  PsResource<ShopInfo> get shopInfo => _shopInfo;
  StreamSubscription<PsResource<ShopInfo>> subscription;
  StreamController<PsResource<ShopInfo>> shopInfoListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ShopInfo Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopInfo() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShopInfoList() async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      await _repo.getShopInfo(
          shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShopInfoList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }
}
