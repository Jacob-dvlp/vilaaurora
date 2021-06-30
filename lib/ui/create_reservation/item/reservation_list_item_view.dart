import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/ps_colors.dart';
import '../../../constant/ps_dimens.dart';
import '../../../utils/utils.dart';

class ReservationListItem extends StatelessWidget {
  const ReservationListItem(
      {Key key,
      @required this.reservation,
      this.onTap,
      this.updateReservationStatus,
      this.animationController,
      @required this.scaffoldKey,
      this.animation})
      : super(key: key);

  final Reservation reservation;
  final Function onTap;
  final Function updateReservationStatus;
  final AnimationController animationController;
  final Animation<double> animation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    if (reservation != null) {
      animationController.forward();
      return AnimatedBuilder(
          animation: animationController,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              color: PsColors.backgroundColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TransactionNoWidget(
                    reservation: reservation,
                    scaffoldKey: scaffoldKey,
                  ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  _TransactionTextWidget(
                      reservation: reservation,
                      updateReservationStatus: updateReservationStatus),
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
              ),
            );
          });
    } else {
      return Container();
    }
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.reservation,
    @required this.scaffoldKey,
  }) : super(key: key);

  final Reservation reservation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      "${Utils.getString(context, 'transaction_reservation')}",
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.subtitle1,
    );
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space4,
          top: PsDimens.space10,
          bottom: PsDimens.space10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(
                FontAwesome.book,
                size: PsDimens.space24,
              ),
              const SizedBox(
                width: PsDimens.space8,
              ),
              _textWidget,
            ],
          ),
          _TransactionStatusWidget(reservation: reservation),
        ],
      ),
    );
  }
}

class _TransactionStatusWidget extends StatelessWidget {
  const _TransactionStatusWidget({
    Key key,
    @required this.reservation,
  }) : super(key: key);

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
          top: PsDimens.space4,
          bottom: PsDimens.space4,
          right: PsDimens.space12,
          left: PsDimens.space12),
      decoration: BoxDecoration(
          color: reservation.reservationstatus.id == '1'
              ? PsConst.PENDING_COLOR
              : reservation.reservationstatus.id == '2'
                  ? PsConst.CANCEL_COLOR
                  : reservation.reservationstatus.id == '3'
                      ? PsConst.CONFIRM_COLOR
                      : reservation.reservationstatus.id == '4'
                          ? PsConst.REJECTE_COLOR
                          : reservation.reservationstatus.id == '5'
                              ? PsConst.COMPLETE_COLOR
                              : PsConst.COMPLETE_COLOR,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Text(
        reservation.reservationstatus.title ?? '-',
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
    );
  }
}

class _TransactionTextWidget extends StatelessWidget {
  const _TransactionTextWidget(
      {Key key,
      @required this.reservation,
      @required this.updateReservationStatus})
      : super(key: key);

  final Reservation reservation;
  final Function updateReservationStatus;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.only(
      left: PsDimens.space16,
      right: PsDimens.space16,
      top: PsDimens.space8,
    );

    final Widget _nameTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_name'),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );

    final Widget _userNameTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space16,
              right: PsDimens.space16,
              top: PsDimens.space6,
              bottom: PsDimens.space6),
          child: Text(
            '${reservation.userName}',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );

    final Widget _dateTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_date'),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );

    final Widget _userDateTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space16,
              right: PsDimens.space16,
              top: PsDimens.space6,
              bottom: PsDimens.space6),
          child: Text(
            '${reservation.resvDate} ${reservation.resvTime} ',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );

    final Widget _restaurnatTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_restaurant'),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );

    final Widget _callRestaurnatTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: 0.0,
                  top: PsDimens.space6,
                  bottom: PsDimens.space6),
              child: const Icon(Icons.call,
                  size: PsDimens.space18, color: Colors.yellow),
            ),
            //Container(
            InkWell(
              child: Text(
                Utils.getString(context, 'transaction_call_restaurant'),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.normal, color: Colors.yellow),
              ),
              onTap: () async {
                if (await canLaunch(
                    'tel://${reservation.shopInfo.aboutPhone1}')) {
                  await launch('tel://${reservation.shopInfo.aboutPhone1}');
                } else {
                  throw 'Could not Call Phone Number 1';
                }
              },
            ),
            //),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
                child: Text(
                  //Utils.getString(context, 'transaction_cancel_booking'),
                  reservation.reservationstatus.id == '1'
                      ? Utils.getString(context, 'transaction_cancel_booking')
                      : reservation.reservationstatus.id == '2'
                          ? Utils.getString(context, '')
                          : reservation.reservationstatus.id == '3'
                              ? Utils.getString(context, '')
                              : reservation.reservationstatus.id == '4'
                                  ? Utils.getString(context, '')
                                  : reservation.reservationstatus.id == '5'
                                      ? Utils.getString(context, '')
                                      : Utils.getString(context, ''),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                      ),
                ),
                onTap: () async {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialogView(
                            description:
                                Utils.getString(context, 'reservation_confirm'),
                            leftButtonText: Utils.getString(
                                context, 'app_info__cancel_button_name'),
                            rightButtonText:
                                Utils.getString(context, 'dialog__ok'),
                            onAgreeTap: () async {
                              Navigator.pop(context);
                              updateReservationStatus();
                            });
                      });
                }),
          ],
        )
      ],
    );

    if (reservation != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _nameTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _userNameTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _dateTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _userDateTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _restaurnatTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _callRestaurnatTextWidget,
          ),
          const SizedBox(
            height: PsDimens.space12,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
