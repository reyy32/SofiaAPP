import 'package:flutter/material.dart';
import '../widgets/product_list_widget.dart';
import '../widgets/user_list_widget.dart';
import '../widgets/puntos_list_widget.dart';

class DashboardScreenAdmin extends StatefulWidget {
  const DashboardScreenAdmin({super.key});

  @override
  State<DashboardScreenAdmin> createState() => _DashboardScreenAdminState();
}

class _DashboardScreenAdminState extends State<DashboardScreenAdmin> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ProductListWidget(),
    UserListWidget(),
    PuntosListWidget(), // si aún no lo usás, podés comentar esta línea
  ];

  final List<String> _titles = const [
    'Productos',
    'Usuarios',
    'Puntos', // si aún no lo usás, podés comentar esta línea
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Puntos',
          ),
        ],
      ),
    );
  }
}
