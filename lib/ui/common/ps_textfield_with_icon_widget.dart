import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/constant/route_paths.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterrestaurant/viewobject/holder/product_parameter_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.psValueHolder});

  final TextEditingController textEditingController;
  final String hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder psValueHolder;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final ProductParameterHolder productParameterHolder =
        ProductParameterHolder().getLatestParameterHolder();
    final Widget _productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space12,
          bottom: PsDimens.space8,
          top: PsDimens.space10,
        ),
        border: InputBorder.none,
        hintText: hintText,
        prefixIcon: InkWell(
            child: Icon(
              Icons.search,
              color: PsColors.iconColor,
            ),
            onTap: () {
              productParameterHolder.searchTerm = textEditingController.text;
              Utils.psPrint(productParameterHolder.searchTerm);
              Navigator.pushNamed(context, RoutePaths.filterProductList,
              arguments: ProductListIntentHolder(
                appBarTitle:
                    Utils.getString(context, 'home_search__app_bar_title'),
                productParameterHolder: productParameterHolder));
            }),
      ),
      onSubmitted: (String value) {
        productParameterHolder.searchTerm = textEditingController.text;
        Utils.psPrint(productParameterHolder.searchTerm);
        Navigator.pushNamed(context, RoutePaths.filterProductList,
            arguments: ProductListIntentHolder(
                appBarTitle:
                    Utils.getString(context, 'home_search__app_bar_title'),
                productParameterHolder: productParameterHolder));
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space4),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
