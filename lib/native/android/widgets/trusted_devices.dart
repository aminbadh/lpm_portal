import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class TrustedDevices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    DocumentSnapshot doc = GlobalData.instance.get('UserDoc');
    Map<String, dynamic> trustedDevices = doc.get('trustedDevices');
    return ListView.builder(
      itemCount: trustedDevices.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                trustedDevices.keys.elementAt(index),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            InkWell(
              onTap: () async {
                String uuid;
                final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                try {
                  var build = await deviceInfoPlugin.androidInfo;
                  uuid = build.androidId;
                } on PlatformException {
                  print('Failed to get platform version');
                }
                if (trustedDevices.values.elementAt(index) == uuid) {
                  Utils.showSnackBar(
                      context,
                      'This is the device you are currently using, '
                      'you cannot remove it from the list.',
                      themeChange);
                } else {
                  String devName = trustedDevices.keys.elementAt(index);
                  trustedDevices.remove(trustedDevices.keys.elementAt(index));
                  Map<String, dynamic> updated = {'trustedDevices': trustedDevices};
                  FirebaseFirestore.instance.doc(doc.reference.path).update(updated).then(
                      (value) => Utils.showSnackBar(context, '$devName is removed', themeChange),
                      onError: (error) => Utils.showSnackBar(context, error.message, themeChange));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.remove,
                  color:
                      themeChange.darkTheme ? Colors.red : Constants.defaultTextColorL.withRed(150),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
