import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class CheckUpgraderWidget extends StatelessWidget {
  const CheckUpgraderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upgrader Example',
      home: UpgradeAlert(
          child: Scaffold(
        appBar: AppBar(title: const Text('Upgrader Example')),
        body: const Center(child: Text('Checking...')),
      )),
    );
  }
}
