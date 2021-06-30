import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/provider/reservation/reservation_list_provider.dart';
import 'package:flutterrestaurant/provider/reservation/reservation_provider.dart';
import 'package:flutterrestaurant/repository/create_reservation_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/error_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/ui/create_reservation/item/reservation_list_item_view.dart';
import 'package:flutterrestaurant/utils/ps_progress_dialog.dart';
import 'package:flutterrestaurant/viewobject/holder/create_reservation_status_holder.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../config/ps_config.dart';
import '../../../constant/ps_dimens.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/common/ps_value_holder.dart';
import '../../common/ps_admob_banner_widget.dart';

class ReservationListView extends StatefulWidget {
  const ReservationListView(
      {Key key, @required this.animationController, @required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _ReservationListViewState createState() => _ReservationListViewState();
}

class _ReservationListViewState extends State<ReservationListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ReservationListProvider _reservationListProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _reservationListProvider.nextReservationList();
      }
    });
    super.initState();
  }

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

  ReservationRepository repo1;
  PsValueHolder valueHolder;
  dynamic data;
  ReservationProvider reservationProvider;
  Reservation reservation;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ReservationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ReservationProvider>(
          lazy: false,
          create: (BuildContext context) {
            reservationProvider =
                ReservationProvider(repo: repo1, psValueHolder: valueHolder);

            return reservationProvider;
          },
        ),
        ChangeNotifierProvider<ReservationListProvider>(
          lazy: false,
          create: (BuildContext context) {
            final ReservationListProvider provider = ReservationListProvider(
                repo: repo1, psValueHolder: valueHolder);
            provider.loadReservationList(valueHolder.loginUserId);
            _reservationListProvider = provider;
            return _reservationListProvider;
          },
        ),
      ],
      child: Consumer<ReservationListProvider>(builder: (BuildContext context,
          ReservationListProvider provider, Widget child) {
        return Column(
          children: <Widget>[
            const PsAdMobBannerWidget(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: PsDimens.space10),
                child: RefreshIndicator(
                  child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.reservationList.data != null ||
                                  provider.reservationList.data.isNotEmpty) {
                                final int count =
                                    provider.reservationList.data.length;
                                return ReservationListItem(
                                  scaffoldKey: widget.scaffoldKey,
                                  animationController:
                                      widget.animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  reservation:
                                      provider.reservationList.data[index],
                                  onTap: () {},
                                  updateReservationStatus: () async {
                                    if (await Utils
                                        .checkInternetConnectivity()) {
                                      final ReservationStatusParameterHolder
                                          contactUsStatusParameterHolder =
                                          ReservationStatusParameterHolder(
                                              userId: valueHolder.loginUserId,
                                              reservationId: provider
                                                  .reservationList
                                                  .data[index]
                                                  .id,
                                              statusId: '2');
                                      await PsProgressDialog.showDialog(
                                          context);
                                      final PsResource<Reservation> _apiStatus =
                                          await reservationProvider
                                              .postReservationStatus(
                                                  contactUsStatusParameterHolder
                                                      .toMap());
                                      if (_apiStatus.data != null) {
                                        PsProgressDialog.dismissDialog();

                                        print('Success');
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SuccessDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'success_dialog__success'),
                                              );
                                            });
                                        provider.resetReservationList();
                                      }
                                    } else {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: Utils.getString(context,
                                                  'error_dialog__no_internet'),
                                            );
                                          });
                                    }
                                  },
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount: provider.reservationList.data.length,
                          ),
                        )
                      ]),
                  onRefresh: () {
                    return provider.resetReservationList();
                  },
                ),
              ),
            ),
            PSProgressIndicator(provider.reservationList.status)
          ],
        );
      }),
    );
  }
}
