
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/ble/flutterBle.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed( const Duration(milliseconds: 3000), () {});

    if(!mounted) return ;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FlutterBlueApp()));
  }

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Scaffold(
          body: Center(
              child: Container(
                height: 3000,
                width: 3000,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              )
          ),
        ),
      );
  }
}
