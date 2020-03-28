import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'model.dart';
import 'package:screen/screen.dart';


enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  // TODO pick colors in the app
  static Color dayTextColor = Colors.green;
  static Color nightTextColor = Colors.red;

  Color textColor = dayTextColor;

  // 7:30 ams
  int alarmMorningHour = 7;
  int alarmMorningMin = 30;

  // 8:00 pm
  int alarmNightHour = 20;
  int alarmNightMin = 0;

  @override
  void initState() {
    super.initState();

    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  void Battery()
  {
    // Instantiate it
    var battery = Battery();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    Screen.keepOn(false);
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {



    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;



    // final hour =
    var hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    // get rid of leading 0
    if(hour.compareTo("10") != 0)
    {
      hour = hour.replaceAll("0", "");
      print("Testing: " + hour);
    }

    // checkAlarmTimeAndSetColor();

    Color textColor = dayTextColor;

    // night alarm check
    if(_dateTime.hour >= alarmNightHour)
    {
      textColor = nightTextColor;
    }

    // morning alarm check
    if(_dateTime.hour <= alarmMorningHour)
    {
      if(_dateTime.minute < alarmMorningMin)
      {
          textColor = nightTextColor;
      }

    }



    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -(fontSize * 0.025);
    final defaultStyle = TextStyle(
      color: textColor, // colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      constraints: BoxConstraints.expand(),
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(left: offset, top: 0, child: Text(hour)),
              Positioned(right: offset, bottom: offset, child: Text(minute)),
            ],
          ),
        ),
      ),
    );
  }


}