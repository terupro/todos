import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/component/cardButton.dart';
import 'package:todos/model/db/db.dart';
import 'package:todos/util/util.dart';
import 'package:todos/view_model/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

Widget card(TodoItemData item, TodoDatabaseNotifier db) {
  return Consumer(
    builder: ((context, ref, child) {
      final _darkModeProvider = ref.watch(darkModeProvider);
      final _darkModeNotifier = ref.watch(darkModeProvider.notifier);
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: kMainBorderRadius,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 1.5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kCardColor(_darkModeProvider),
            borderRadius: kMainBorderRadius,
            boxShadow: [
              BoxShadow(
                offset: const Offset(4, 4),
                color: kCardTopShadow(_darkModeProvider),
                blurRadius: 6,
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(-3, -3),
                color: kCardBottomShadow(_darkModeProvider),
                blurRadius: 6,
                inset: true,
              ),
            ],
          ),
          child: ListTile(
            horizontalTitleGap: 5,
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kTextColor(_darkModeProvider),
              ),
            ),
            trailing: cardButton(
              () async {
                await db.deleteData(item);
                HapticFeedback.heavyImpact();
              },
              Icons.close,
              kIconDeleteColor(_darkModeProvider),
            ),
          ),
        ),
      );
    }),
  );
}
