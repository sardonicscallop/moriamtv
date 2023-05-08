import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum UiMessageType {
  error,
  warning,
  info
}

class UiMessageHandler extends StatelessWidget {
  final UiMessageType messageType;
  final String messageText;

  UiMessageHandler({Key? key, required this.messageText, required this.messageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData icon;

    switch(messageType) {
      case UiMessageType.error:
        icon = MdiIcons.alertOctagon;
        break;
      case UiMessageType.warning:
        icon = MdiIcons.alert;
        break;
      case UiMessageType.info:
        icon = MdiIcons.information;
        break;
    }

    return Center(
      child: Column(
        children: [
          Icon(icon, size: Theme.of(context).iconTheme.size == null ? 24.0 * 3 : Theme.of(context).iconTheme.size! * 3),
          Text(messageText)
        ],
      ),
    );
  }
}