import 'package:flutterrestaurant/api/common/ps_resource.dart';

import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/user/user_provider.dart';
import 'package:flutterrestaurant/repository/user_repository.dart';
import 'package:flutterrestaurant/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterrestaurant/ui/common/dialog/error_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_textfield_widget.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/holder/change_password_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  UserRepository userRepo;
  PsValueHolder psValueHolder;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    return PsWidgetWithAppBar<UserProvider>(
        appBarTitle: Utils.getString(context, 'change_password__title') ?? '',
        initProvider: () {
          return UserProvider(repo: userRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (UserProvider provider) {
          return provider;
        },
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(PsDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'change_password__password'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'change_password__password'),
                    textEditingController: passwordController),
                PsTextFieldWidget(
                    titleText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textAboutMe: false,
                    hintText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textEditingController: confirmPasswordController),
                Container(
                  margin: const EdgeInsets.all(PsDimens.space16),
                  child: PsButtonWidget(
                    provider: provider,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                ),
                _largeSpacingWidget,
              ],
            ),
          ));
        });
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    @required this.passwordController,
    @required this.confirmPasswordController,
    @required this.provider,
  });

  final TextEditingController passwordController, confirmPasswordController;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'edit_profile__save'),
        onPressed: () async {
          if (passwordController.text != '' &&
              confirmPasswordController.text != '') {
            if (passwordController.text == confirmPasswordController.text) {
              if (await Utils.checkInternetConnectivity()) {
                final ChangePasswordParameterHolder contactUsParameterHolder =
                    ChangePasswordParameterHolder(
                        userId: provider.psValueHolder.loginUserId,
                        userPassword: passwordController.text);

                final PsResource<ApiStatus> _apiStatus = await provider
                    .postChangePassword(contactUsParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  passwordController.clear();
                  confirmPasswordController.clear();

                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: _apiStatus.data.status,
                        );
                      });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: _apiStatus.message,
                        );
                      });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'error_dialog__no_internet'),
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'change_password__not_equal'),
                    );
                  });
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString(context, 'change_password__error'),
                  );
                });
          }
        });
  }
}
