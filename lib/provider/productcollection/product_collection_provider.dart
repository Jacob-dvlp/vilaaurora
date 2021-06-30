import 'dart:async';

import 'package:flutterrestaurant/repository/product_collection_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';

class ProductCollectionProvider extends PsProvider {
  ProductCollectionProvider(
      {@required ProductCollectionRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ProductCollection Provider: $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<ProductCollectionHeader>>>.broadcast();
    subscription =
        productCollectionListStream.stream.listen((dynamic resource) {
      //Utils.psPrint("ProductCollectionHeader Provider : ");

      updateOffset(resource.data.length);

      _productCollectionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    productCollectionStream =
        StreamController<PsResource<ProductCollectionHeader>>.broadcast();
    subscriptionById =
        productCollectionStream.stream.listen((dynamic resource) {
      _productCollection = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ProductCollectionRepository _repo;

  PsResource<List<ProductCollectionHeader>> _productCollectionList =
      PsResource<List<ProductCollectionHeader>>(
          PsStatus.NOACTION, '', <ProductCollectionHeader>[]);

  PsResource<ProductCollectionHeader> _productCollection =
      PsResource<ProductCollectionHeader>(PsStatus.NOACTION, '', null);

  PsResource<List<ProductCollectionHeader>> get productCollectionList =>
      _productCollectionList;

  PsResource<ProductCollectionHeader> get productCollection =>
      _productCollection;

  StreamSubscription<PsResource<List<ProductCollectionHeader>>> subscription;
  StreamController<PsResource<List<ProductCollectionHeader>>>
      productCollectionListStream;

  StreamSubscription<PsResource<ProductCollectionHeader>> subscriptionById;
  StreamController<PsResource<ProductCollectionHeader>> productCollectionStream;
  @override
  void dispose() {
    subscription.cancel();
    subscriptionById.cancel();
    isDispose = true;
    print('Product Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductCollectionList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getProductCollectionList(productCollectionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProductCollectionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageProductCollectionList(productCollectionListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductCollectionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getProductCollectionList(productCollectionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
