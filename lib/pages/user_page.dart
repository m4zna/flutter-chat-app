import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(online: true, email: 'test1@test', name: 'Brenda', uid: '1'),
    User(online: true, email: 'test2@test', name: 'Carolina', uid: '2'),
    User(online: false, email: 'test3@test', name: 'Osorio', uid: '3'),
    User(online: true, email: 'test4@test', name: 'Gonzalez', uid: '4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Mi Nombre', style: TextStyle(color: Colors.black54)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black54),
            onPressed: () {},
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
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
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0, 2)),
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
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
