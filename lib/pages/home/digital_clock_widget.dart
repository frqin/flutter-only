import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalClockWidget extends StatefulWidget {
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const DigitalClockWidget({
    Key? key,
    this.textColor,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  State<DigitalClockWidget> createState() => _DigitalClockWidgetState();
}

class _DigitalClockWidgetState extends State<DigitalClockWidget> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _getTimeString();
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        _timeString = _getTimeString();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getTimeString() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: GoogleFonts.inriaSans(
        color: widget.textColor ?? Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 2.0,
      ),
    );
  }
}
