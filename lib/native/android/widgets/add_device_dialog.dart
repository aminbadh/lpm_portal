import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class AddDeviceDialog extends StatefulWidget {
  final Function onDone;
  final Function(Map<String, dynamic>) onContains;
  final Function(FirebaseException) onError;

  const AddDeviceDialog({this.onDone, this.onContains, this.onError});

  @override
  _AddDeviceDialogState createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _uuidController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return AlertDialog(
      title: Text(
        'Add a new device',
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: Constants.inputDecoration('Device Name', themeChange),
                validator: (val) => val.isEmpty ? 'Please enter your device name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _uuidController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: Constants.inputDecoration('UUID', themeChange),
                validator: (val) => val.length < 16 ? 'Please enter a valid UUID' : null,
              ),
            ]),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop();
              DocumentSnapshot doc = GlobalData.instance.get('UserDoc');
              Map<String, dynamic> trustedDevices = doc.get('trustedDevices');
              String devName = _nameController.text;
              String devUUID = _uuidController.text;
              if (trustedDevices.values.contains(devUUID) ||
                  trustedDevices.keys.contains(devName)) {
                widget.onContains(trustedDevices);
              } else {
                trustedDevices.addAll({devName: devUUID});
                Map<String, dynamic> updated = {'trustedDevices': trustedDevices};
                FirebaseFirestore.instance
                    .doc(doc.reference.path)
                    .update(updated)
                    .then((value) => widget.onDone(), onError: (error) => widget.onError(error));
              }
            }
          },
          child: Text(
            'Add device',
            style: GoogleFonts.ibmPlexSerif(),
          ),
          style: ElevatedButton.styleFrom(
            primary: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
            onPrimary:
                themeChange.darkTheme ? Constants.defaultTextColorL : Constants.defaultTextColorD,
          ),
        ),
      ],
    );
  }
}
