import 'package:flutter/foundation.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/repository/Common/ps_repository.dart';

class PsProvider extends ChangeNotifier {
  PsProvider(this.psRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  PsRepository psRepository;

  int offset = 0;
  int limit = PsConfig.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
   await psRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
   await psRepository.replaceLoginUserId(loginUserId);
  }

  Future<void> replaceLoginUserName(String loginUserName) async {
   await psRepository.replaceLoginUserName(loginUserName);
  }

  Future<void> replaceNotiToken(String notiToken) async {
   await psRepository.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiMessage(String message) async {
   await psRepository.replaceNotiMessage(message);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
   await psRepository.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
   await psRepository.replaceIsToShowIntroSlider(doNotShowAgain);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
   await psRepository.replaceDate(startDate, endDate);
  }

  Future<void> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
   await psRepository.replaceVerifyUserData(userIdToVerify, userNameToVerify,
        userEmailToVerify, userPasswordToVerify);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
  await  psRepository.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
   await psRepository.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<void> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
    String minimumOrderAmount,
  ) async {
  await  psRepository.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone,
        minimumOrderAmount);
  }

  Future<void> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String paystackEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
  await  psRepository.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        paystackEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<void> replacePublishKey(String pubKey) async {
   await psRepository.replacePublishKey(pubKey);
  }

  Future<void> replacePayStackKey(String payStackKey) async {
  await  psRepository.replacePayStackKey(payStackKey);
  }
}
