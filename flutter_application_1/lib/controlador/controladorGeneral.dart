import 'package:flutter_application_1/peticiones/peticionesDB.dart';
import 'package:get/get.dart';

class controladorGeneral extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaPos = Rxn<List<Map<String, dynamic>>>();
/////////////////////////////////////////////////////
  
final _coordenadas = "".obs;

void cargaCoordenadas(String X){
  _coordenadas.value = X;
}

String get coordenadas => _coordenadas.value;

void carga_listaPos(List<Map<String, dynamic>> X){
  _listaPos.value = X;
}
  List<Map<String, dynamic>>? get ListaPos => _listaPos.value;
 ///////////////////////////////////////////////////////////// 
  Future<void> CargarTodaBD() async {
    final datos = await PeticionesDB.ListarTodos();
    carga_listaPos(datos);
  }
}