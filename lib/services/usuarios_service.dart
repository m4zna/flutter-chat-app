import 'package:chat/global/enviroment.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;


class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {'Content-Type': 'application/json', 'x-token': await AuthService.getToken()});
      final usuariosResponse = usuariosResponseFromJson(response.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      print(e);
      return [];
    }
  }
}