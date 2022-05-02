import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/util/util.dart';
import 'package:todos/view_model/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:spring_button/spring_button.dart';

// Button
Widget cardButton(VoidCallback press, IconData icon, Color color) {
  return Consumer(
    builder: ((context, ref, child) {
      final _darkModeProvider = ref.watch(darkModeProvider);
      final _darkModeNotifier = ref.watch(darkModeProvider.notifier);
      return SpringButton(
        SpringButtonType.OnlyScale,
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: kMainBorderRadius,
            boxShadow: [
              BoxShadow(
                offset: const Offset(3, 3),
                color:
                    _darkModeProvider == true ? Colors.white70 : Colors.white,
                blurRadius: 2,
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(-1, -1),
                color:
                    _darkModeProvider == true ? Colors.black : Colors.black54,
                blurRadius: 2,
                inset: true,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(
              icon,
              size: 30,
              color: _darkModeProvider == true ? Colors.white70 : Colors.white,
            ),
          ),
        ),
        onTap: press,
        onTapDown: (_) {},
        onLongPress: null,
        onLongPressEnd: null,
        useCache: false,
        alignment: Alignment.center,
        scaleCoefficient: 0.75,
        duration: 1000,
      );
    }),
  );
}
