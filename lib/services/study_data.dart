
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudyData {
  static final FirebaseFirestore _banco =
      FirebaseFirestore.instance;

  // Identifica o usuário que está conectado.
  static String get _usuarioId {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum usuário conectado.');
    }

    return usuario.uid;
  }

  // Acesso às matérias do usuário.
  static CollectionReference<Map<String, dynamic>>
      get materias {
    return _banco
        .collection('users')
        .doc(_usuarioId)
        .collection('subjects');
  }

  // Acesso às tarefas do usuário.
  static CollectionReference<Map<String, dynamic>>
      get tarefasBanco {
    return _banco
        .collection('users')
        .doc(_usuarioId)
        .collection('tasks');
  }

  // Listas antigas, mantidas temporariamente
  // para evitar erros nas telas existentes.
  static final List<Map<String, String>> tarefas = [];

  static final List<Map<String, String>> compromissos = [];

  static CollectionReference<Map<String, dynamic>>
    get compromissosBanco {
  return _banco
      .collection('users')
      .doc(_usuarioId)
      .collection('compromissos');
}
}
