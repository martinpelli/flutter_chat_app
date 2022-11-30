import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(online: true, email: 'martin@gail.com', name: 'Martin', uid: '1'),
    User(online: false, email: 'juan@gail.com', name: 'Juan', uid: '2'),
    User(online: true, email: 'martin@sdgail.com', name: 'Perez', uid: '3')
  ];

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            authService.user?.name ?? '',
            style: const TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ),
              onPressed: () {
                authService.deleteJWTInStorage();
                Navigator.pushReplacementNamed(context, 'login');
              }),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ),
            )
          ],
        ),
        body: SmartRefresher(
            controller: _refreshController,
            onRefresh: _loadUsers,
            header: WaterDropHeader(
              waterDropColor: Colors.blue[400]!,
              complete: Icon(
                Icons.check,
                color: Colors.blue[400],
              ),
            ),
            child: _UsersList(users: users)));
  }

  void _loadUsers() async {
    await Future.delayed(Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: ((_, index) => _UserTile(user: users[index])),
        separatorBuilder: ((_, index) => const Divider()),
        itemCount: users.length);
  }
}

class _UserTile extends StatelessWidget {
  final User user;

  const _UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: user.online ? Colors.green[300] : Colors.red, borderRadius: BorderRadius.circular(100))),
    );
  }
}
