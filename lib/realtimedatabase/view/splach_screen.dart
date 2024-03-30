import 'package:firebase_tech/realtimedatabase/firebase_services/splach_services.dart';
import 'package:flutter/material.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {

  final _splachServices=  SplachServices();
  @override
  void initState() {
    super.initState();
    _splachServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Firebase Tutorial ..."),
      ),
    );
  }
}
