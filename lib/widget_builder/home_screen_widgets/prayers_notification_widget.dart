import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class PrayersNotificationWidget extends StatelessWidget {
  final String payerName;
  final DateTime prayerTime;
  const PrayersNotificationWidget({super.key, required this.payerName, required this.prayerTime});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(S.of(context).PrayerNotification),
        notificationCard(payerName, prayerTime)
      ],
    );
  }
}


Widget notificationCard (String prayerName, DateTime prayerTime) => Row(
  children: [
    Expanded(child: Text(prayerName)),
    Switch(
      value: true,
      onChanged: (value) {
        print(prayerTime);
      },
    ),
  ],
);