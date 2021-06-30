import 'package:flutter/cupertino.dart';
import 'package:flutterrestaurant/viewobject/transaction_header.dart';

class CheckoutStatusIntentHolder {
  const CheckoutStatusIntentHolder({
    @required this.transactionHeader,
  });

  final TransactionHeader transactionHeader;
}
