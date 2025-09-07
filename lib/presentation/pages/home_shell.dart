import 'package:flutter/material.dart';
import '../../shared/constants/app_constants.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Serenithy'),
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          _HomeTab(),
          _DiaryTab(),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: AppColors.primary,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Diario'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Ajustes'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Inicio'));
}

class _DiaryTab extends StatelessWidget {
  const _DiaryTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Diario'));
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Ajustes'));
}


