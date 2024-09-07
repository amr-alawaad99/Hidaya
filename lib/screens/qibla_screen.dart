import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';


class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500),);
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  bool hasPermission = false;

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then((value) {
          setState(() {
            hasPermission = (value == PermissionStatus.granted);
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(hasPermission);
    return SafeArea(
      child: FutureBuilder(
        future: getPermission(),
        builder: (context, snapshot) {
          if (hasPermission) {
            return Scaffold(
              body: StreamBuilder(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(alignment: Alignment.center, child: const CircularProgressIndicator(color: Colors.white,));
                  }

                  final qiblahDirection = snapshot.data;
                  animation = Tween(begin: begin, end: (qiblahDirection!.qiblah * (pi / 180) * -1)).animate(_animationController!);
                  begin = (qiblahDirection.qiblah * (pi / 180) * -1);
                  _animationController!.forward(from: 0);

                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "${qiblahDirection.direction.toInt()}°",
                          //   style: const TextStyle(color: Colors.white, fontSize: 24),
                          // ),
                          Icon(Icons.arrow_drop_down_sharp, size: 130.sp, color: Colors.white,),

                          SizedBox(
                              height: 350.h,
                              child: AnimatedBuilder(
                                animation: animation!,
                                builder: (context, child) => Transform.rotate(
                                    angle: animation!.value,
                                    child: Image.asset('assets/images/qiblah.png')),
                              ))
                        ]),
                  );
                },
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Color.fromARGB(255, 48, 48, 48),
            );
          }
        },
      ));
  }
}