import 'dart:async';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/db/transaction_status_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/api/ps_api_service.dart';
import 'package:flutterrestaurant/viewobject/transaction_status.dart';

import 'Common/ps_repository.dart';

class TransactionStatusRepository extends PsRepository {
  TransactionStatusRepository(
      {@required PsApiService psApiService,
      @required TransactionStatusDao transactionStatusDao}) {
    _psApiService = psApiService;
    _transactionStatusDao = transactionStatusDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  TransactionStatusDao _transactionStatusDao;

  Future<dynamic> insert(TransactionStatus transactionStatus) async {
    return _transactionStatusDao.insert(primaryKey, transactionStatus);
  }

  Future<dynamic> update(TransactionStatus transactionStatus) async {
    return _transactionStatusDao.update(transactionStatus);
  }

  Future<dynamic> delete(TransactionStatus transactionStatus) async {
    return _transactionStatusDao.delete(transactionStatus);
  }

  Future<dynamic> getAllTransactionStatusList(
      StreamController<PsResource<List<TransactionStatus>>>
          transactionStatusListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    transactionStatusListStream.sink
        .add(await _transactionStatusDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<TransactionStatus>> _resource =
          await _psApiService.getTransactionStatusList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _transactionStatusDao.deleteAll();
        await _transactionStatusDao.insertAll(primaryKey, _resource.data);
        
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _transactionStatusDao.deleteAll();
        }
      }
      transactionStatusListStream.sink
            .add(await _transactionStatusDao.getAll());
    }
  }

  Future<dynamic> getNextPageTransactionStatusList(
      StreamController<PsResource<List<TransactionStatus>>>
          transactionStatusListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    transactionStatusListStream.sink
        .add(await _transactionStatusDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<TransactionStatus>> _resource =
          await _psApiService.getTransactionStatusList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _transactionStatusDao.insertAll(primaryKey, _resource.data);
      }
      transactionStatusListStream.sink
          .add(await _transactionStatusDao.getAll());
    }
  }
}
