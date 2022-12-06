import 'package:flutter/material.dart';
import 'package:flutter_application_1/controlador/controladorGeneral.dart';
import 'package:flutter_application_1/peticiones/peticionesDB.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => _listarState();
}

class _listarState extends State<listar> {
  controladorGeneral Control = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Control.CargarTodaBD();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        child: Control.ListaPos?.isEmpty == false
            ? ListView.builder(
                itemCount: Control.ListaPos!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          Alert(
                                  title: "Atencion!!!",
                                  desc:
                                      "Esta seguro que desea eliminar la posición?",
                                  buttons: [
                                    DialogButton(
                                        color: Colors.blue,
                                        child: Text("Si"),
                                        onPressed: () {
                                          PeticionesDB.EliminarPosiciones(
                                              Control.ListaPos![index]["id"]);
                                          Control.CargarTodaBD();
                                          Navigator.pop(context);
                                        }),
                                    DialogButton(
                                        color: Colors.orange,
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                  context: context)
                              .show();
                        },
                        icon: Icon(Icons.delete_forever_rounded)),
                    leading: Icon(Icons.location_searching_sharp),
                    title: Text(Control.ListaPos![index]["coordenadas"]),
                    subtitle: Text(Control.ListaPos![index]["fechahora"]),
                  ));
                },
              )
            : Center(child: CircularProgressIndicator())));
  }
}
