import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class DisplayLinksComponent extends StatefulWidget {
  @override
  _DisplayLinksComponentState createState() => _DisplayLinksComponentState();
}

class _DisplayLinksComponentState extends State<DisplayLinksComponent> {
  String text = "No Link has been received yet";
  StreamSubscription? incomingUrlStreamSubscription;

  void _handleInitialUrl() async {
    final uri = await getInitialUri();

    if (uri != null) {
      setState(() {
        text = uri.toString();
      });
    }
  }

  void _handleIncomingUrl() {
    incomingUrlStreamSubscription = uriLinkStream.listen((Uri? uri) {
      setState(() {
        text = uri.toString();
      });
    });
  }

  @override
  void initState() {
    _handleInitialUrl();
    _handleIncomingUrl();
    super.initState();
  }

  @override
  void dispose() {
    incomingUrlStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The link associated with notification will appear here When clicked',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(text,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                textAlign: TextAlign.start)
          ],
        ));
  }
}
