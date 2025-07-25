import 'package:flutter/cupertino.dart';

import '../enums/DeviceType.dart';
DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double deviceWidth = 0;
  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQueryData.size.height;
  } else {
    deviceWidth = mediaQueryData.size.width;
  }
  if (deviceWidth > 950) {
    return DeviceType.desktop;
  } else if (deviceWidth > 600) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}