import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveAdaptiveApp());
}

class ResponsiveAdaptiveApp extends StatelessWidget {
  const ResponsiveAdaptiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool useCupertino = !kIsWeb && Platform.isIOS;

    if (useCupertino) {
      return const CupertinoApp(
        title: 'Responsive Adaptive Dashboard',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          primaryColor: Color(0xFF1F1F1F),
          scaffoldBackgroundColor: Color(0xFFE7E7E7),
        ),
        home: DashboardPage(),
      );
    }

    return MaterialApp(
      title: 'Responsive Adaptive Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F1F1F)),
        scaffoldBackgroundColor: const Color(0xFFE7E7E7),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 680) {
          return _MobileDashboard();
        }

        if (width < 1024) {
          return _TabletDashboard();
        }

        return _DesktopDashboard();
      },
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final useCupertino = !kIsWeb && Platform.isIOS;

    return Scaffold(
      backgroundColor: const Color(0xFFE7E7E7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _miniCard(),
                  _miniCard(),
                  _miniCard(),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 110,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 110,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFBFBF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFCECECE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFCECECE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFCECECE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Column(
                  children: [
                    _exampleListCard(),
                    const SizedBox(height: 14),
                    _exampleListCard(),
                    const SizedBox(height: 14),
                    _exampleListCard(),
                    const SizedBox(height: 14),
                    _exampleListCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildAdaptiveNavBar(useCupertino),
    );
  }
}

class _TabletDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final useCupertino = !kIsWeb && Platform.isIOS;

    return Scaffold(
      backgroundColor: const Color(0xFFE7E7E7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.home_outlined, color: Colors.black54),
                    const SizedBox(width: 10),
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    ...List.generate(3, (index) {
                      final icons = [
                        Icons.settings_outlined,
                        Icons.info_outline,
                        Icons.logout,
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icons[index], size: 18, color: Colors.black54),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _miniCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _miniCard()),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _exampleListCard(),
                          const SizedBox(height: 18),
                          _exampleListCard(),
                          const SizedBox(height: 18),
                          _exampleListCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      width: 170,
                      child: _examplePanelCard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildAdaptiveNavBar(useCupertino),
    );
  }
}

class _DesktopDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E7E7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD7D7D7),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      bottomLeft: Radius.circular(26),
                    ),
                  ),
                  child: _SidebarContent(isCompact: false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _miniCard()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _miniCard()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _miniCard()),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _exampleListCard(),
                                          const SizedBox(height: 18),
                                          _exampleListCard(),
                                          const SizedBox(height: 18),
                                          _exampleListCard(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 210,
                                      child: _examplePanelCard(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  const _SidebarContent({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
      _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
      _NavItem(icon: Icons.info_outline, label: 'About'),
      _NavItem(icon: Icons.logout, label: 'Logout'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: isCompact ? 42 : 58,
            height: isCompact ? 42 : 58,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 26),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: isCompact ? 14 : 22),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: Colors.black54),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: isCompact ? 11 : 13,
                    letterSpacing: 0.6,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

Widget _buildAdaptiveNavBar(bool useCupertino) {
  if (useCupertino) {
    return CupertinoTabBar(
      backgroundColor: const Color(0xFFF4F4F4),
      activeColor: const Color(0xFF1A1A1A),
      inactiveColor: const Color(0xFF8A8A8A),
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.info_circle), label: 'About'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_arrow_left), label: 'Logout'),
      ],
    );
  }

  return NavigationBar(
    backgroundColor: const Color(0xFFF3F3F3),
    elevation: 0,
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      NavigationDestination(icon: Icon(Icons.info_outline), label: 'About'),
      NavigationDestination(icon: Icon(Icons.logout), label: 'Logout'),
    ],
  );
}

Widget _exampleListCard() {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFD9D9D9),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFCBCBCB),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8C8C8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 90,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8C8C8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _examplePanelCard() {
  return Container(
    height: 390,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFD9D9D9),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFBDBDBD)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFBFBFBF),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5C5C5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFCECECE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFBEBEBE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8B8B8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5C5C5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFBFBFBF),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFBFBFBF),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _miniCard() {
  return Container(
    width: 78,
    height: 78,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFD8D8D8),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFBEBEBE)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFC5C5C5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const Spacer(),
        Container(
          width: 34,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFB8B8B8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    ),
  );
}
