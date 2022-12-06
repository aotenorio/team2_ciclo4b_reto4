import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class PeticionesDB {
  static Future<void> CrearTabla(sql.Database database) async {
    await database.execute(""" CREATE TABLE posiciones (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    coordenadas TEXT,
    fechahora TEXT
    ) """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("minticgeo.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await CrearTabla(database);
    });
  }

  static Future<void> guardarPosicion(coor, feho) async {
    final db = await PeticionesDB.db();
    final datos = {"coordenadas": coor, "fechahora": feho};
    await db.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm
            .replace); //para evitar datos duplicados usar el conflictalgoritm
  }

  static Future<List<Map<String, dynamic>>> ListarTodos() async {
    final db = await PeticionesDB.db();
    return db.query("posiciones", orderBy: "fechahora");
  }

  static Future<void> EliminarPosiciones(int idpos) async {
    final db = await PeticionesDB.db();
    db.delete("posiciones", where: "id=?", whereArgs: [idpos]);
  }

  static Future<void> EliminarTodasPosiciones() async {
    final db = await PeticionesDB.db();
    db.delete("posiciones");
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('El GPS no se encuentra activado, por favor activela');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('El uso de la localización ha sido negado');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'El uso de la localización ha sido negada permanentemente.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
