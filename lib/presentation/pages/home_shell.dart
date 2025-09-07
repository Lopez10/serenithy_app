import 'package:flutter/material.dart';
import '../../shared/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/food_list_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../domain/repositories/food_repository.dart';

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodListBloc(
        getIt<IFoodRepository>(),
      )..add(const LoadFirstPage()),
      child: BlocBuilder<FoodListBloc, FoodListState>(
        builder: (context, state) {
          if (state is FoodListLoading || state is FoodListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FoodListError) {
            return Center(child: Text(state.error.message));
          }
          final loaded = state as FoodListLoaded;
          final items = loaded.items;

          return NotificationListener<ScrollEndNotification>(
            onNotification: (notif) {
              if (!notif.metrics.outOfRange && loaded.hasMore &&
                  notif.metrics.pixels == notif.metrics.maxScrollExtent) {
                context.read<FoodListBloc>().add(const LoadNextPage());
              }
              return false;
            },
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              physics: const PageScrollPhysics(),
              itemBuilder: (context, index) {
                final name = items[index].name;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder de imagen a pantalla completa (color lila suave)
                    Container(color: AppColors.primarySoft),
                    // Degradado superior e inferior para legibilidad
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x66000000), // negro 40%
                            Color(0x00000000),
                            Color(0x33000000), // negro 20%
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    // Título del alimento centrado
                    Center(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
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


