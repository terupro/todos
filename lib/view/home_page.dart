import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/component/cardButton.dart';
import 'package:todos/main.dart';
import 'package:todos/model/db/db.dart';
import 'package:todos/model/freezed/todo.dart';
import 'package:todos/util/util.dart';
import 'package:todos/view_model/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todos/component/allCard.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 入力中のtodoのインスタンスを作成
  TempTodoItemData temp = TempTodoItemData();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final _darkModeNotifier = ref.watch(darkModeProvider.notifier);
    setState(() {
      _darkModeNotifier.state = prefs.getBool('themeSetting')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 状態が変化するたびに再ビルドする
    final todoProvider = ref.watch(todoDatabaseProvider);

    // メソッドや値を取得する
    final todoNotifierProvider = ref.watch(todoDatabaseProvider.notifier);

    // 追加画面を閉じたら再ビルドするために使用する
    List<TodoItemData> todoItems = todoNotifierProvider.state.todoItems;

    // 日付
    String getTodayDate() {
      initializeDateFormatting('ja');
      return (DateFormat('yMMMEd', 'ja').format(DateTime.now())).toString();
    }

    // コントローラ
    final textController = TextEditingController();

    // Providerの監視
    final _darkModeProvider = ref.watch(darkModeProvider);
    final _darkModeNotifier = ref.watch(darkModeProvider.notifier);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: kCardColor(_darkModeProvider),
                    borderRadius: kMainBorderRadius,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(6, 6),
                        color: kCardTopShadow(_darkModeProvider),
                        blurRadius: 10,
                        inset: true,
                      ),
                      BoxShadow(
                        offset: const Offset(-4, -4),
                        color: kCardBottomShadow(_darkModeProvider),
                        blurRadius: 10,
                        inset: true,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TODOS',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                getTodayDate(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: IconButton(
                              onPressed: () async {
                                if (_darkModeProvider == true) {
                                  _darkModeNotifier.state = false;
                                } else {
                                  _darkModeNotifier.state = true;
                                }
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool(
                                    'themeSetting', _darkModeNotifier.state);
                                setState(() {
                                  prefs.getBool('themeSetting');
                                });
                                HapticFeedback.heavyImpact();
                              },
                              icon: Icon(
                                Icons.brightness_6_outlined,
                                color: kTextColor(_darkModeProvider),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kCardColor(_darkModeProvider),
                                borderRadius: kMainBorderRadius,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(-3, -3),
                                    color: kCardTopShadow(_darkModeProvider),
                                    blurRadius: 3,
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: kCardBottomShadow(_darkModeProvider),
                                    blurRadius: 3,
                                    inset: true,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: textController,
                                onChanged: (value) {
                                  temp = temp.copyWith(title: value);
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor(_darkModeProvider),
                                ),
                                decoration: InputDecoration(
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kTextFieldBorderColor(
                                        _darkModeProvider,
                                      ),
                                      width: 2,
                                    ),
                                    borderRadius: kMainBorderRadius,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kTextFieldBorderColor(
                                        _darkModeProvider,
                                      ),
                                      width: 2,
                                    ),
                                    borderRadius: kMainBorderRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: cardButton(() async {
                              await todoNotifierProvider.writeData(temp);
                              textController.text = '';
                              temp = temp.copyWith(title: '');
                              HapticFeedback.heavyImpact();
                            }, Icons.add, kIconAddColor(_darkModeProvider)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.3),
                  child: ListView(
                    children: allCard(todoItems, todoNotifierProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
