import 'package:flutter/material.dart';

class EntityPickerDialog extends StatefulWidget {
  const EntityPickerDialog({Key? key}) : super(key: key);

  @override
  _EntityPickerDialogState createState() => _EntityPickerDialogState();
}

class _EntityPickerDialogState extends State<EntityPickerDialog> {
  /*TextEditingController searchBoxController = new TextEditingController();
  String filter = "";
  List<SearchResultCategory>9im resultsList = [];*/

  @override
  void initState() {
    super.initState();

    /*searchBoxController.addListener(() {
      setState(() {
        filter = searchBoxController.text;
      });
    });*/
  }

  @override
  void dispose() {
    //searchBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is a typical dialog.'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        )
    );
  }
}
