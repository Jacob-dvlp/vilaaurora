import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/reservation/create_reservation_provider.dart';
import 'package:flutterrestaurant/provider/user/user_provider.dart';
import 'package:flutterrestaurant/repository/create_reservation_repository.dart';
import 'package:flutterrestaurant/repository/user_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/error_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_textfield_widget.dart';
import 'package:flutterrestaurant/utils/ps_progress_dialog.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterrestaurant/viewobject/holder/create_reservation_holder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class CreateReservationView extends StatefulWidget {
  const CreateReservationView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _CreateReservationViewState createState() => _CreateReservationViewState();
}

class _CreateReservationViewState extends State<CreateReservationView> {
  ReservationRepository reservationRepository;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController reservationDateController =
      TextEditingController();
  final TextEditingController reservationTimeController =
      TextEditingController();
  final TextEditingController userNoteController = TextEditingController();
  String timePeriod = '';
  TimeOfDay timePicked;
  DateTime todayTime;
  DateTime dateTime;
  PsValueHolder psValueHolder;
  bool bindDataFirstTime = true;
  UserRepository userRepository;
  CreateReservationProvider reservationProvider;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    reservationRepository = Provider.of<ReservationRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    userRepository = Provider.of<UserRepository>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    dynamic bindingTime(TimeOfDay todayTime, TimeOfDay timePicked) {
      if (timePicked.period == DayPeriod.am) {
        timePeriod = 'AM';
      } else {
        timePeriod = 'PM';
      }
      final String minute = timePicked.minute.toString() == PsConst.ZERO
          ? '00'
          : todayTime.minute.toString();
      todayTime = timePicked.replacing(hour: timePicked.hour);

      reservationTimeController.text = todayTime.hour.toString() +
          ' : ' +
          minute +
          ' ' +
          timePeriod.toString();
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<CreateReservationProvider>(
          lazy: false,
          create: (BuildContext context) {
            reservationProvider = CreateReservationProvider(
                repo: reservationRepository, psValueHolder: psValueHolder);

            return reservationProvider;
          },
        ),
        ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            final UserProvider provider = UserProvider(
                repo: userRepository, psValueHolder: psValueHolder);
            provider.getUser(provider.psValueHolder.loginUserId);
            return provider;
          },
        ),
      ],
      child: Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider userProvider, Widget child) {
        if (userProvider != null &&
            userProvider.user != null &&
            userProvider.user.data != null) {
          if (bindDataFirstTime) {
            userNameController.text = userProvider.user.data.userName;
            userEmailController.text = userProvider.user.data.userEmail;
            userPhoneController.text = userProvider.user.data.userPhone;
            bindDataFirstTime = false;
          }
          return AnimatedBuilder(
              animation: widget.animationController,
              child: SingleChildScrollView(
                  child: Container(
                padding: const EdgeInsets.all(PsDimens.space8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PsDropdownBaseWithControllerWidget(
                        title: Utils.getString(
                            context, 'create_reservation__reservation_date'),
                        textEditingController: reservationDateController,
                        isMandatory: true,
                        onTap: () async {
                          final DateTime today = DateTime.now();
                          Utils.psPrint('Today is ' + today.toString());
                          dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: today,
                              lastDate: DateTime(2025));

                          if (dateTime != null) {
                            reservationProvider.reservationDate =
                                DateFormat('dd/MM/yyyy').format(dateTime);

                            Utils.psPrint('Today Date format is ' +
                                reservationProvider.reservationDate);
                          }

                          reservationDateController.text =
                              reservationProvider.reservationDate;
                          reservationTimeController.text = '';
                        }),
                    PsDropdownBaseWithControllerWidget(
                        title: Utils.getString(
                            context, 'create_reservation__reservation_time'),
                        textEditingController: reservationTimeController,
                        isMandatory: true,
                        onTap: () async {
                          final TimeOfDay todayTime = TimeOfDay.now();
                          if (reservationDateController.text == null ||
                              reservationDateController.text == '') {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WarningDialog(
                                    message: Utils.getString(context,
                                        'create_reservation__warning_reservation_date'),
                                    onPressed: () {},
                                  );
                                });
                          } else {
                            if (dateTime.day == DateTime.now().day) {
                              final TimeOfDay todayTime = TimeOfDay.now();

                              timePicked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child,
                                  );
                                },
                              );

                              if (timePicked.hour < TimeOfDay.now().hour ||
                                  (timePicked.hour <= TimeOfDay.now().hour &&
                                      timePicked.minute <
                                          TimeOfDay.now().minute)) {
                                reservationTimeController.text = '';

                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorDialog(
                                        message: Utils.getString(context,
                                            'create_reservation__error_selected_time'),
                                      );
                                    });
                              } else {
                                bindingTime(todayTime, timePicked);
                              }
                            } else {
                              timePicked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child,
                                  );
                                },
                              );
                              print('next day');

                              bindingTime(todayTime, timePicked);
                            }
                          }
                        }),
                    PsTextFieldWidget(
                        titleText: Utils.getString(
                            context, 'create_reservation__user_name'),
                        textAboutMe: false,
                        hintText: Utils.getString(
                            context, 'create_reservation__user_name_hint'),
                        textEditingController: userNameController,
                        isMandatory: true),
                    PsTextFieldWidget(
                        titleText: Utils.getString(
                            context, 'create_reservation__user_email'),
                        textAboutMe: false,
                        hintText: Utils.getString(
                            context, 'create_reservation__user_email_hint'),
                        textEditingController: userEmailController),
                    PsTextFieldWidget(
                        titleText: Utils.getString(
                            context, 'create_reservation__user_phone'),
                        textAboutMe: false,
                        hintText: Utils.getString(
                          context,
                          'create_reservation__user_phone_hint',
                        ),
                        keyboardType: TextInputType.phone,
                        phoneInputType: true,
                        textEditingController: userPhoneController,
                        isMandatory: true),
                    PsTextFieldWidget(
                        titleText: Utils.getString(
                            context, 'create_reservation__user_note'),
                        textAboutMe: false,
                        height: PsDimens.space160,
                        hintText: Utils.getString(
                            context, 'create_reservation__user_note_hint'),
                        textEditingController: userNoteController),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16,
                          top: PsDimens.space16,
                          right: PsDimens.space16,
                          bottom: PsDimens.space40),
                      child: PsButtonWidget(
                        provider: reservationProvider,
                        userProvider: userProvider,
                        userNameTextController: userNameController,
                        userEmailTextController: userEmailController,
                        userPhoneTextController: userPhoneController,
                        userNoteTextController: userNoteController,
                        reservationDateController: reservationDateController,
                        reservationTimeController: reservationTimeController,
                      ),
                    ),
                    _largeSpacingWidget,
                  ],
                ),
              )),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child,
                    ));
              });
        } else {
          return Container();
        }
      }),
    );
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget(
      {@required this.userNameTextController,
      @required this.userEmailTextController,
      @required this.userPhoneTextController,
      @required this.userNoteTextController,
      @required this.reservationDateController,
      @required this.reservationTimeController,
      @required this.provider,
      @required this.userProvider});

  final TextEditingController userNameTextController,
      userEmailTextController,
      userPhoneTextController,
      userNoteTextController,
      reservationDateController,
      reservationTimeController;
  final CreateReservationProvider provider;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);

    return PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'contact_us__submit'),
        onPressed: () async {
          if (provider.reservationDate == null) {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(context,
                        'create_reservation__warning_reservation_date'),
                    onPressed: () {},
                  );
                });
          } else if (reservationTimeController.text == null ||
              reservationTimeController.text == '') {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(context,
                        'create_reservation__warning_reservation_time'),
                    onPressed: () {},
                  );
                });
          } else if (userNameTextController.text == '' ||
              userNameTextController.text == null) {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'create_reservation__warning_user_name'),
                    onPressed: () {},
                  );
                });
          } else if (userPhoneTextController.text == '' ||
              userPhoneTextController.text == null) {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'create_reservation__warning_user_phone'),
                    onPressed: () {},
                  );
                });
          } else {
            if (await Utils.checkInternetConnectivity()) {
              final ReservationParameterHolder contactUsParameterHolder =
                  ReservationParameterHolder(
                      reservationDate: provider.reservationDate,
                      reservationTime: reservationTimeController.text,
                      // reservationDate: '23/5/2020',
                      // reservationTime: '12:00',
                      userNote: userNoteTextController.text,
                      shopId: psValueHolder.shopId,
                      userId: psValueHolder.loginUserId,
                      userEmail: userProvider.user.data.userEmail,
                      userPhoneNumber: userProvider.user.data.userPhone,
                      userName: userProvider.user.data.userName);

              await PsProgressDialog.showDialog(context);
              final PsResource<ApiStatus> _apiStatus = await provider
                  .postReservation(contactUsParameterHolder.toMap());

              if (_apiStatus.data != null) {
                PsProgressDialog.dismissDialog();
                print('Success');
                reservationDateController.text = '';
                reservationTimeController.text = '';
                userEmailTextController.clear();
                userPhoneTextController.clear();
                userNameTextController.clear();
                userNoteTextController.clear();
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      if (_apiStatus.data.status == 'success') {
                        return SuccessDialog(
                          message: _apiStatus.data.status,
                        );
                      } else {
                        return ErrorDialog(
                          message: _apiStatus.data.status,
                        );
                      }
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          }
        });
  }
}
