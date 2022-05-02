import 'package:flutter/material.dart';

final kMainBorderRadius = BorderRadius.circular(15);

Color kTextColor(bool state) {
  return state == true ? Colors.white70 : Colors.black54;
}

Color kCardColor(bool state) {
  return state == true ? const Color(0xFF1A1A1A) : Colors.white;
}

Color kCardTopShadow(bool state) {
  return state == true ? const Color(0xFF637180) : Colors.white;
}

Color kCardBottomShadow(bool state) {
  return state == true ? Colors.black : const Color(0xFFA7A9AF);
}

Color kTextFieldBorderColor(bool state) {
  return state == true ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);
}

Color kIconAddColor(bool state) {
  return state == true
      ? const Color(0xFF8EC298).withOpacity(0.8)
      : const Color(0xFF8EC298);
}

Color kIconDeleteColor(bool state) {
  return state == true
      ? const Color(0xFFFF9494).withOpacity(0.8)
      : const Color(0xFFFF9494);
}
