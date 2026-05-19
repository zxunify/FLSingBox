import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/app_database.dart' as db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = db.AppDatabase(
    driftDatabase(
      name: 'flsingbox',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        db.appDatabaseProvider.overrideWithValue(database),
      ],
      child: const FlSingBoxApp(),
    ),
  );
}
