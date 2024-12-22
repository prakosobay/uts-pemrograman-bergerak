import 'package:flutter/material.dart';
import 'package:password_manager/database/helper.database.dart';
import 'package:password_manager/helper/encrypt.helper.dart';
import 'package:password_manager/screen/home.screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  Future<void> ensureUsersTableExists() async {
    final db = await DatabaseHelper().database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        username TEXT,
        password TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  Future<void> _register() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty || _fullnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username, Fullname and Password must be filled!')),
      );
      print(_fullnameController);
      return;
    }

    await ensureUsersTableExists();

    final db = await DatabaseHelper().database;

    String encryptedPassword = EncryptionHelper.encryptPassword(
      _passwordController.text, 
      _usernameController.text,
    );

    try {
      await db.insert('users', {
        'username': _usernameController.text,
        'password': encryptedPassword,
        'fullname': _fullnameController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Registration failed: $_fullnameController')),
        SnackBar(content: Text('Registration failed: Username might already be exists')),
      );
    }
  }
  

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    try {
      final result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [_usernameController.text],
      );

      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
        return;
      }

      String encryptedPassword = result[0]['password'] as String;

      String decryptedPassword = EncryptionHelper.decryptPassword(
        encryptedPassword, 
        _usernameController.text, 
      );

      if (decryptedPassword == _passwordController.text) {
        final userId = result.first['id'] as int;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: userId),
          ),
        );
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password!')),
        );
      }

      // if (result.isNotEmpty) {
        
      //   final userId = result.first['id'] as int;
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomeScreen(userId: userId),
      //     ),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Invalid username or password')),
      //   );
      // }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed!')),
      );
    }
  }

  @override
  Widget build (BuildContext content) {
    return Scaffold(
      appBar: AppBar(title : Text('Login/Register')),
      body : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration( labelText: 'Full Name'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration( labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, 
              child: Text('Login')
            ),
            TextButton(
              onPressed: _register, 
              child: Text('Create Account')
            ),
          ],
        ),
      ),
    );
  }
}