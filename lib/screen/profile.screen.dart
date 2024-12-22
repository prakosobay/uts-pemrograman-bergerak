import 'package:flutter/material.dart';
import 'package:password_manager/database/helper.database.dart';
import 'package:password_manager/screen/login.screen.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;

  const ProfileScreen({ required this.userId, Key ? key}) : super(key : key);

  Future<Map<String, dynamic>> _fetchUSerData() async {
    final db = await DatabaseHelper().database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return results.isNotEmpty ? results.first : {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUSerData(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('User data not found'));
        }

        final userData = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('profile', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 20),
              Text('Username : ${userData['username']}'),
              Text('Fullname : ${userData['fullname']}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, 
                  );
                }, child: Text('Logout')
              ),
            ],
          ),
        );
      }
    );
  }
}
