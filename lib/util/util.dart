import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:good_health/page/login.dart';
import 'package:good_health/util/session.dart';

dialog(context, msg, {title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Perhatian!'),
        content: Text(msg.toString()),
      );
    },
  );
}

// Template button lebar utk posisi bottomNavigationBar
Widget largetButton(
    {String label = "Simpan", IconData? iconData, Function? onPressed}) {
  iconData = iconData ?? Icons.done_all;
  return SizedBox(
    height: 60,
    width: double.infinity,
    child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 4.0,
          backgroundColor: Colors.blue,
          disabledForegroundColor: Colors.grey.withOpacity(0.38),
          disabledBackgroundColor: Colors.grey.withOpacity(0.12),
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        icon: Icon(iconData, color: Colors.white),
        onPressed: () {}),
  );
}

// fungsi format tulisan rupiah
String toRupiah(int val) {
  final formatter = NumberFormat.currency(locale: 'ID');
  return formatter.format(val);
}

void logOut(BuildContext context) {
  clearSession().then((value) {
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return const LoginPage();
      }, transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }),
      (route) => false,
    );
  });
}
