import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'db.g.dart';

// テーブルの作成
class TodoItem extends Table {
  // ①主キー（autoIncrementで自動的にIDを設置する）
  IntColumn get id => integer().autoIncrement()();
  // ②タイトル（デフォルト値と長さを指定する）
  TextColumn get title =>
      text().withDefault(const Constant('')).withLength(min: 1)();
}

// データベースの場所を指定
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // db.sqliteファイルをアプリのドキュメントフォルダに置く
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.splite'));
    return NativeDatabase(file);
  });
}

// データベースの実行
@DriftDatabase(tables: [TodoItem])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());
  // テーブルと列を変更するときに使用する
  @override
  int get schemaVersion => 1;

  // 全てのデータの取得
  Future<List<TodoItemData>> readAllTodoData() => select(todoItem).get();

  // データの追加
  Future writeTodo(TodoItemCompanion data) => into(todoItem).insert(data);

  // データの更新
  Future updateTodo(TodoItemData data) => update(todoItem).replace(data);

  // データの削除
  Future deleteTodo(int id) =>
      (delete(todoItem)..where((it) => it.id.equals(id))).go();
}
