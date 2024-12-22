import 'package:flutter/material.dart';
import 'package:password_manager/helper/encrypt.helper.dart';
import '../model/password.model.dart';
import '../database/helper.database.dart';

class PasswordScreen extends StatefulWidget {
  final int userId;

  PasswordScreen({required this.userId});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  List<Password> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> results = await db.query(
      'passwords', 
      where: 'userId=?',
      whereArgs: [widget.userId],
    );
    setState(() {
      _passwords = results.map((map) => Password.fromMap(map)).toList();
    });
  }

  Future<void> _addOrEditPassword({Password? password}) async {

    final titleContoller = TextEditingController(
      text: password != null ? password.title : ''
    );
    final usernameController = TextEditingController(
      text: password != null ? password.username : ''
    );
    final passwordController = TextEditingController(
      text: password != null
          ? EncryptionHelper.decryptPassword(password.password, password.username)
          : '',
    );

    // String decryptedPassword = EncryptionHelper.decryptPassword(
    //   usernameController.text, 
    //   passwordController.text, 
    // );

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(password == null ? 'Add New Password' : 'Edit Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleContoller,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: password == null ? true : false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = await DatabaseHelper().database;

              String encryptedPassword = EncryptionHelper.encryptPassword(
                passwordController.text, 
                usernameController.text,
              );

              if(password == null) {
                
                await db.insert('passwords', {
                  'userid' : widget.userId,
                  'title': titleContoller.text,
                  'username': usernameController.text,
                  'password' : encryptedPassword,
                });
              } else {
                await db.update('passwords', {
                  'title': titleContoller.text,
                  'username' : usernameController.text,
                  'password' : encryptedPassword,
                },
                where : 'id = ? AND userId = ?',
                whereArgs: [password.id, widget.userId]
                );
              }

              Navigator.pop(context); _loadPasswords();
            },
            child: Text(password == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePassword(Password password) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'passwords', 
      where: 'id = ? AND userId = ?', 
      whereArgs: [password.id, widget.userId]
    );
    _loadPasswords();
  }

  @override
  Widget build(BuildContext content) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Passwords')),
      body: ListView.builder(
        itemCount: _passwords.length,
        itemBuilder: (context, index) {
          final password = _passwords[index];
          return ListTile(
            title: Text(password.title),
            subtitle: Text(password.username),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _addOrEditPassword(password: password),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () => _deletePassword(password),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditPassword(),
        child: Icon(Icons.add),
      ),
    );
  }
}
