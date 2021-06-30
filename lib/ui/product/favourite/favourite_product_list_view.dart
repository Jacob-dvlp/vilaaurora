import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/constant/route_paths.dart';
import 'package:flutterrestaurant/provider/product/favourite_product_provider.dart';
import 'package:flutterrestaurant/repository/product_repository.dart';
import 'package:flutterrestaurant/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/ui/product/item/product_vertical_list_item.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterrestaurant/viewobject/product.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider _favouriteProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<FavouriteProductProvider>(
      lazy: false,
      create: (BuildContext context) {
        final FavouriteProductProvider provider =
            FavouriteProductProvider(repo: repo1, psValueHolder: psValueHolder);
        provider.loadFavouriteProductList();
        _favouriteProductProvider = provider;
        return _favouriteProductProvider;
      },
      child: Consumer<FavouriteProductProvider>(
        builder: (BuildContext context, FavouriteProductProvider provider,
            Widget child) {
          if (provider.favouriteProductList != null &&
              provider.favouriteProductList.data != null &&
              provider.favouriteProductList.data.isNotEmpty) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space4,
                            right: PsDimens.space4,
                            top: PsDimens.space4,
                            bottom: PsDimens.space4),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220,
                                          childAspectRatio: 0.6),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.favouriteProductList.data !=
                                              null ||
                                          provider.favouriteProductList.data
                                              .isNotEmpty) {
                                        final int count = provider
                                            .favouriteProductList.data.length;
                                        return ProductVeticalListItem(
                                          coreTagKey:
                                              provider.hashCode.toString() +
                                                  provider.favouriteProductList
                                                      .data[index].id,
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          product: provider
                                              .favouriteProductList.data[index],
                                          onTap: () async {
                                            final Product product = provider
                                                .favouriteProductList
                                                .data[index];
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                              productId: product.id,
                                              heroTagImage:
                                                  provider.hashCode.toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  provider.hashCode.toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__TITLE,
                                              heroTagOriginalPrice: provider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst
                                                      .HERO_TAG__ORIGINAL_PRICE,
                                              heroTagUnitPrice: provider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                            );

                                            await Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);

                                            await provider
                                                .resetFavouriteProductList();
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: provider
                                        .favouriteProductList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetFavouriteProductList();
                          },
                        )),
                    PSProgressIndicator(provider.favouriteProductList.status)
                  ]),
                )
              ],
            );
          } else {
            widget.animationController.forward();
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: const Interval(0.5 * 1, 1.0,
                        curve: Curves.fastOutSlowIn)));
            return AnimatedBuilder(
              animation: widget.animationController,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: PsDimens.space120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/empty_fav.png',
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: PsDimens.space32,
                      ),
                      Text(
                        Utils.getString(context, 'fav_list__empty_title'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(),
                      ),
                      const SizedBox(
                        height: PsDimens.space20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            PsDimens.space32, 0, PsDimens.space32, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              Utils.getString(context, 'fav_list__empty_desc'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child,
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
