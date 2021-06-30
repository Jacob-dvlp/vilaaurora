import 'dart:io';

import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/ps_app_version.dart';
import 'package:flutter/material.dart';

class ForceUpdateView extends StatelessWidget {
  ForceUpdateView({@required this.psAppVersion});
  final PSAppVersion psAppVersion;
  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/fs_android_3x.png',
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        color: PsColors.mainLightColor,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space80,
                    ),
                    _imageWidget,
                    const SizedBox(
                      height: PsDimens.space16,
                    ),
                    Text(Utils.getString(context, 'app_name'),
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16, right: PsDimens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space32,
                    ),
                    Text(psAppVersion.versionTitle,
                        style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Container(
                        height: PsDimens.space100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            psAppVersion.versionMessage,
                            maxLines: 9,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space32, right: PsDimens.space32),
                      child: MaterialButton(
                        color: PsColors.mainColor,
                        height: 45,
                        minWidth: double.infinity,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Text(
                          Utils.getString(context, 'force_update__update'),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.white),
                        ),
                        onPressed: () async {
                          if (Platform.isIOS) {
                            Utils.launchAppStoreURL(
                                iOSAppId: PsConfig.iOSAppStoreId);
                          } else if (Platform.isAndroid) {
                            Utils.launchURL();
                          }
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
