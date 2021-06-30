import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareAppDialog extends StatefulWidget {
  const ShareAppDialog({this.message, this.onPressed});
  final String message;
  final Function onPressed;

  @override
  _ShareAppDialogState createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ShareAppDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(PsDimens.space8),
                margin:  const EdgeInsets.all(PsDimens.space8),
                child: 
                    Text(
                      Utils.getString(context, 'share_app'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PsColors.mainColorWithBlack,fontSize: PsDimens.space18
                      ),
                    ),
                ),
            Container(
              width: 200,
              child: PSButtonWidget(
                   hasShadow: true,
                   titleText: Utils.getString(
                       context, 'share_android_app'),
                   onPressed: () async {
                     final Size size = MediaQuery.of(context).size;
                       Share.share(
                           PsConfig.GOOGLE_PLAY_STORE_URL,
                          
                          sharePositionOrigin:
                              Rect.fromLTWH(0, 0, size.width, size.height / 2),
                        );
                         Navigator.pop(context);
                    },
                    
                    ),
            ),
            const SizedBox(height: PsDimens.space20),
           Container(
              width: 200,
              child: PSButtonWidget(
                   hasShadow: true,
                   titleText: Utils.getString(
                       context, 'share_ios_app'),
                   onPressed: () async {
                      final Size size = MediaQuery.of(context).size;
                       Share.share(
                           PsConfig.APPLE_APP_STORE_URL,
                          
                          sharePositionOrigin:
                              Rect.fromLTWH(0, 0, size.width, size.height / 2),
                        );
                         Navigator.pop(context);},
                    ),
            ),
             const SizedBox(height: PsDimens.space20),
          ],
        ),
      ),
    );
  }
}
