import 'dart:async';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/repository/category_repository.dart';
import 'package:flutterrestaurant/viewobject/category.dart';

class TrendingCategoryProvider extends PsProvider {
  TrendingCategoryProvider(
      {@required CategoryRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Trending Category Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    categoryListStream =
        StreamController<PsResource<List<Category>>>.broadcast();
    subscription =
        categoryListStream.stream.listen((PsResource<List<Category>> resource) {
      updateOffset(resource.data.length);

      _categoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Category>>> categoryListStream;
  CategoryRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Category>> _categoryList =
      PsResource<List<Category>>(PsStatus.NOACTION, '', <Category>[]);

  PsResource<List<Category>> get categoryList => _categoryList;
  StreamSubscription<PsResource<List<Category>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Trending Category Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTrendingCategoryList(
      Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo.getCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getTrendingParameterHolder(),
          PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> nextTrendingCategoryList(
      Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getTrendingParameterHolder(),
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTrendingCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo.getCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getTrendingParameterHolder(),
          PsStatus.PROGRESS_LOADING);
    }
    isLoading = false;
    return isConnectedToInternet;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
