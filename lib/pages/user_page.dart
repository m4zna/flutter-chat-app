import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    Usuario(online: true, email: 'test1@test', nombre: 'Brenda', uid: '1'),
    Usuario(online: true, email: 'test2@test', nombre: 'Carolina', uid: '2'),
    Usuario(online: false, email: 'test3@test', nombre: 'Osorio', uid: '3'),
    Usuario(online: true, email: 'test4@test', nombre: 'Gonzalez', uid: '4'),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
          title: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black54),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue[400],
                ))
          ]),
      body: SmartRefresher(
        controller: _refreshController,
        child: _listViewUsers(),
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        onRefresh: () async {
          _loadUsers();
        },
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(Usuario user) {
    return ListTile(
        title: Text(user.nombre),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: user.online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100),
            )));
  }

  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
