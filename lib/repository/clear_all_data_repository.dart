import 'dart:async';

import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/db/basket_dao.dart';
import 'package:flutterrestaurant/db/blog_dao.dart';
import 'package:flutterrestaurant/db/category_map_dao.dart';
import 'package:flutterrestaurant/db/cateogry_dao.dart';
import 'package:flutterrestaurant/db/comment_detail_dao.dart';
import 'package:flutterrestaurant/db/comment_header_dao.dart';
import 'package:flutterrestaurant/db/product_collection_header_dao.dart';
import 'package:flutterrestaurant/db/product_dao.dart';
import 'package:flutterrestaurant/db/product_map_dao.dart';
import 'package:flutterrestaurant/db/rating_dao.dart';
import 'package:flutterrestaurant/db/sub_category_dao.dart';
import 'package:flutterrestaurant/db/transaction_detail_dao.dart';
import 'package:flutterrestaurant/db/transaction_header_dao.dart';
import 'package:flutterrestaurant/repository/Common/ps_repository.dart';
import 'package:flutterrestaurant/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final CommentHeaderDao _commentHeaderDao = CommentHeaderDao.instance;
    final CommentDetailDao _commentDetailDao = CommentDetailDao.instance;
    final BasketDao _basketDao = BasketDao.instance;
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ProductCollectionDao _productCollectionDao =
        ProductCollectionDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final SubCategoryDao _subCategoryDao = SubCategoryDao();
    final TransactionHeaderDao _transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao _transactionDetailDao =
        TransactionDetailDao.instance;
    final BlogDao _blogDao = BlogDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _commentHeaderDao.deleteAll();
    await _commentDetailDao.deleteAll();
    await _basketDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productCollectionDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();
    await _transactionHeaderDao.deleteAll();
    await _transactionDetailDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
