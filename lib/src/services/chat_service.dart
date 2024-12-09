import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getResponse(String message) async {
    if (message.toLowerCase().contains("accidente")) {
      return "Por favor, describe el tipo de accidente (vehicular, caída, etc.)";
    } else if (message.toLowerCase().contains("vehicular")) {
      final doctor = "Dr. García";
      return "Gracias. Un $doctor estará con usted en 10 minutos.";
    } else {
      return "Por favor, proporciona más detalles sobre la emergencia.";
    }
  }

  Future<void> saveEmergencyData(Map<String, String> data) async {
    await _firestore.collection("emergencias").add(data);
  }
}
