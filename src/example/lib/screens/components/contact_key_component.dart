import 'package:flutter/material.dart';
import 'package:sfmc_plugin/sfmc_plugin.dart';

class ContactKeyComponent extends StatefulWidget {
  const ContactKeyComponent({Key? key}) : super(key: key);

  @override
  _ContactKeyComponentState createState() => _ContactKeyComponentState();
}

class _ContactKeyComponentState extends State<ContactKeyComponent> {
  late TextEditingController contactKeyController = TextEditingController();

  String? predefinedContactKey;

  Future<bool?> _setContactKey(String contactKey) async {
    var value = await SfmcPlugin().setContactKey(contactKey);
    setState(() {
      predefinedContactKey = contactKey;
    });
    return value;
  }

  Future<String?> _getContactKey() async {
    String? contactKey = await SfmcPlugin().getContactKey();
    setState(() {
      predefinedContactKey = contactKey;
    });
    return contactKey;
  }

  @override
  void initState() {
    _getContactKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasPredefinedContactKey = predefinedContactKey != null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasPredefinedContactKey)
            Wrap(
              children: [
                const Text("You've set a contact key, which is : "),
                Text(predefinedContactKey!,
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w500))
              ],
            ),
          if (!hasPredefinedContactKey)
            const Text("No contact key is detected, please submit a new one"),
          const SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (text) => contactKeyController.text = text,
            decoration: const InputDecoration(
                hintText: 'Enter a new contact key',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                _setContactKey(contactKeyController.text.trim());
              },
              child: const Text("Submit")),
          Text(
            "It might take up to 10-20 minutes to set the contact key for the first time",
            style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
