import 'package:flutter/material.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/shop_info/shop_info_provider.dart';
import 'package:flutterrestaurant/repository/shop_info_repository.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class TermsAndRefundView extends StatefulWidget {
  const TermsAndRefundView({@required this.title, @required this.description});
  final String title;
  final String description;
  @override
  _TermsAndRefundViewState createState() => _TermsAndRefundViewState();
}

class _TermsAndRefundViewState extends State<TermsAndRefundView> {
  ShopInfoRepository repo1;
  PsValueHolder psValueHolder;
  ShopInfoProvider provider;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ShopInfoRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return ChangeNotifierProvider<ShopInfoProvider>(
        lazy: false,
        create: (BuildContext context) {
          provider = ShopInfoProvider(
              repo: repo1,
              psValueHolder: psValueHolder,
              ownerCode: 'TermsAndRefundView');
          provider.loadShopInfo();
          return provider;
        },
        child: Consumer<ShopInfoProvider>(builder: (BuildContext context,
            ShopInfoProvider basketProvider, Widget child) {
          if (provider.shopInfo.data == null) {
            return Container();
          } else {
            return Padding(
                padding: const EdgeInsets.all(PsDimens.space10),
                child: SingleChildScrollView(
                    child: widget.description == PsConst.TERMS_FLAG
                        ? Text(provider.shopInfo.data.terms)
                        : widget.description == PsConst.REFUND_FLAG
                            ? Text(provider.shopInfo.data.refundPolicy)
                            : ''));
          }
        }));
  }
}
