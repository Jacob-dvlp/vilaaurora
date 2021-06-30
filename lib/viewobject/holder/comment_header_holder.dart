import 'package:flutterrestaurant/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class CommentHeaderParameterHolder
    extends PsHolder<CommentHeaderParameterHolder> {
  CommentHeaderParameterHolder(
      {@required this.userId,
      @required this.productId,
      @required this.headerComment});

  final String userId;
  final String productId;
  final String headerComment;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['product_id'] = productId;
    map['header_comment'] = headerComment;

    return map;
  }

  @override
  CommentHeaderParameterHolder fromMap(dynamic dynamicData) {
    return CommentHeaderParameterHolder(
      userId: dynamicData['user_id'],
      productId: dynamicData['product_id'],
      headerComment: dynamicData['header_comment'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (productId != '') {
      key += productId;
    }

    if (headerComment != '') {
      key += headerComment;
    }
    return key;
  }
}
