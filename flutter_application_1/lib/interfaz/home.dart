import 'package:flutter/material.dart';
import 'package:flutter_application_1/controlador/controladorGeneral.dart';
import 'package:flutter_application_1/interfaz/listar.dart';
import 'package:flutter_application_1/interfaz/mapa.dart';
import 'package:flutter_application_1/peticiones/peticionesDB.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'GeoApp By TenoDEV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controladorGeneral Control = Get.find();

  void obtenerCoordenadas() async {

    Position coor= await PeticionesDB.determinePosition();
    Control.cargaCoordenadas(coor.toString());
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        title: "Atención",
                        desc:
                            "Estas seguro que desea eliminar TODAS LAS COORDENADAS ALMACENADAS?",
                        buttons: [
                          DialogButton(
                              color: Colors.purple,
                              child: Text("SI"),
                              onPressed: () {
                                PeticionesDB.EliminarTodasPosiciones();
                                Control.CargarTodaBD();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.teal,
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        context: context)
                    .show();
              },
              icon: Icon(Icons.delete_sweep))
        ],
      ),
      body: listar(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_on_outlined),
          onPressed: () {
            Alert(
                    type: AlertType.info,
                    title: "Atencion!!!",
                    buttons: [
                      DialogButton(
                          color: Colors.green,
                          child: Text("SI"),
                          onPressed: () {
                            obtenerCoordenadas();
                            PeticionesDB.guardarPosicion(
                               Control.coordenadas, DateTime.now().toString());
                            Control.CargarTodaBD();
                            MapLauncherDemo();
                            Navigator.pop(context);
                          }),
                      DialogButton(
                          color: Colors.red,
                          child: Text("NO"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                    desc:
                        "Esta seguro que desea almacenar su coordenada actual?",
                    context: context)
                .show();
          }),
    );
  }
}
