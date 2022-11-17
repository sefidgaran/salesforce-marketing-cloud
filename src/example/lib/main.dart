import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfmc_plugin/sfmc_plugin.dart';
import 'package:sfmc_prototype/screens/components/contact_key_component.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  final String title = "SFMC - Mobile Push";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future handler(MethodCall methodCall) async {
  switch (methodCall.method) {
    case 'handle_url':
      var url = methodCall.arguments['url'];
      // the url is accessible here and can be processed (Applicable to iOS Only)
      return null;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool? initStatus;

  late TextEditingController tagController = TextEditingController();

  void onInit() async {
    SfmcPlugin().setHandler(handler);
    var isInitialized = await SfmcPlugin().initialize(
      appId: '<YOUR_APP_ID>',
      accessToken: '<YOUR_ACCESS_TOKEN>',
      mid: '<YOUR_MID>',
      sfmcURL: '<YOUR_SFMC_URL>',
      senderId: '<YOUR_FIREBASE_CLOUD_MESSAGING_SENDER_ID>',

      /// Set delayRegistration on iOS only,
      /// delayRegistration on Android is by default true
      delayRegistration: true,

      /// Set analytics on iOS only,
      /// analytics on Android is by default true
      analytics: true,
    );

    setState(() {
      initStatus = isInitialized;
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool initSucceeded = (initStatus != null && initStatus == true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          initStatusDisplay(initStatus),
          const SizedBox(
            height: 15,
          ),
          if (initSucceeded) const ContactKeyComponent(),
        ],
      ),
    );
  }

  Widget initStatusDisplay(bool? isInitSuccessful) {
    String text = 'Trying to initialize ...';
    bool isLoading = isInitSuccessful == null;
    if (!isLoading) {
      if (isInitSuccessful) {
        text = "The cloud messaging system has been initialized !";
      } else {
        text = "There was an error during initializing the cloud system !";
      }
    }
    return SizedBox(
      child: Column(
        children: [
          if (isLoading)
            const SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildSectionContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5)),
      child: child,
    );
  }
}
