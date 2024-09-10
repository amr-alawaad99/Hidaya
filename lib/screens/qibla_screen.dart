import 'dart:math';
import 'package:Hidaya/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import '../generated/l10n.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  @override
  void dispose() {
    FlutterQiblah().dispose(); // Dispose the Qiblah Stream
    super.dispose();
  }

  Future<bool> getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        return true;
      } else {
        var result = await Permission.location.request();
        return result == PermissionStatus.granted;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FutureBuilder<bool>(
      future: getPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData && snapshot.data == true) {
          return Scaffold(
            body: StreamBuilder<QiblahDirection>(
              stream: FlutterQiblah.qiblahStream, // The Qiblah stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasData) {
                  final qiblahDirection = snapshot.data;
                  double angle = (qiblahDirection!.qiblah * (pi / 180) * -1);
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50.h,),
                        MaterialButton(
                          color: Constants.primaryColor,
                          onPressed: () {
                            showDialog(context: context, builder: (context) => Dialog(
                              child: Image.asset("assets/images/calibrate_compass.gif",),
                            ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(S.of(context).CompassCalibration, style: Theme.of(context).textTheme.bodySmall,),
                              SizedBox(width: 10.w,),
                              Icon(TablerIcons.compass, size: 30.sp,),
                            ],
                          ),
                        ),
                        SizedBox(height: 50.h,),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 130.sp,
                          color: brightness == Brightness.light
                              ? Constants.primaryColor
                              : Colors.white,
                        ),
                        SizedBox(
                          height: 350.h,
                          child: Transform.rotate(
                            angle: angle,
                            child: brightness == Brightness.light
                                ? Image.asset('assets/images/qiblah_light.png')
                                : Image.asset('assets/images/qiblah_dark.png'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return const Center(child: Text("No Data"));
                }
              },
            ),
          );
        }
        else {
          return Center(
            child: Text(
              S.of(context).PermissionDeniedMessage,
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
