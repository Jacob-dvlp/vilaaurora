import 'dart:async';

import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/repository/product_repository.dart';
import 'package:flutterrestaurant/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterrestaurant/viewobject/product.dart';

class SearchProductProvider extends PsProvider {
  SearchProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;

  ProductParameterHolder productParameterHolder;

  bool isSwitchedFeaturedProduct = false;
  bool isSwitchedDiscountPrice = false;

  String selectedCategoryName = '';
  String selectedSubCategoryName = '';

  String categoryId = '';
  String subCategoryId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Search Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByKey(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    if (isConnectedToInternet) {
      await _repo.getProductList(productListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> loadProductListByKeyFromDB(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    await _repo.getProductListFromDB(productListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
  }

  Future<dynamic> nextProductListByKey(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      print('*** Next Page Loading $limit $offset');
      await _repo.getNextPageProductList(
          productListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }

  Future<void> resetLatestProductList(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;
    await _repo.getProductList(productListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, productParameterHolder);
  }
}
