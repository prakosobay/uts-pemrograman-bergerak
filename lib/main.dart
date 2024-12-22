import 'package:flutter/material.dart';
import 'package:password_manager/screen/login.screen.dart';
// import 'package:password_manager/screen/password.screen.dart';
// import 'package:password_manager/screen/profile.screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => LoginScreen()
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Password Manager',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     PasswordScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Passwords'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
