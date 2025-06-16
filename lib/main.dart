import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:tubes_apb/workshopAcademic.dart';
import 'package:tubes_apb/workshopNonAcademic.dart';
import 'package:tubes_apb/cart.dart';
import 'mapsPage.dart';
import 'adminWorkshop.dart';
import 'adminPayments.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartComp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const WorkshopAcademic();
      case 1:
        return const WorkshopNonAcademic();
      case 2:
        return const CartPage();
      case 3:
        return const MapsPage();
      case 4:
        return const AdminWorkshopPage();
      case 5:
        return const AdminPaymentPage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SmartComp'),
            Row(
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width: 10),
                Icon(Icons.notifications),
                SizedBox(width: 10),
                Icon(Icons.person),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple.shade200,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Academic'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), label: 'Non-Academic'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings), label: 'Admin WS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Admin Pay'),
        ],
      ),
    );
  }
}
