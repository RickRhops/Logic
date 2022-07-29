import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';


class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static Provider<AppDatabase> provider = Provider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);

    return database;
  });

  Future<List<Note>> get getNotesInDatabase => select(notes).get(); 
  
  Stream<List<Note>> watchNotesInDatabase() => select(notes).watch();

  Future deleteNote(Note note) => delete(notes).delete(note);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}