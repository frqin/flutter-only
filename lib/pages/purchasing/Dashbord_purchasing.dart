import 'package:ekspedisi/pages/purchasing/Form_Purchasing_impor.dart';
import 'package:ekspedisi/pages/purchasing/Form_purchasing_Lokal.dart';
import 'package:ekspedisi/pages/purchasing/SeleksiPemasok.dart';
import 'package:flutter/material.dart';

class PurchasingDashboardPage extends StatefulWidget {
  const PurchasingDashboardPage({super.key});

  @override
  State<PurchasingDashboardPage> createState() =>
      _PurchasingDashboardPageState();
}

class _PurchasingDashboardPageState extends State<PurchasingDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each card
    _fadeAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      3,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.2,
                0.6 + (index * 0.2),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Purchasing Dashboard",
          style: TextStyle(
            fontFamily: 'InriaSans',
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE8EAED)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _controller,
                    child: const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontFamily: 'InriaSans',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeTransition(
                    opacity: _controller,
                    child: const Text(
                      "Kelola aktivitas purchasing Anda",
                      style: TextStyle(
                        fontFamily: 'InriaSans',
                        fontSize: 15,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Menu Utama",
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedCard(
                    index: 0,
                    icon: Icons.shopping_bag_outlined,
                    title: "Purchasing Lokal",
                    subtitle: "Input pembelian lokal",
                    color: const Color.fromARGB(255, 23, 23, 23),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PurchaseFormPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildAnimatedCard(
                    index: 1,
                    icon: Icons.language_outlined,
                    title: "Purchasing Impor",
                    subtitle: "Input pembelian impor",
                    color: const Color.fromARGB(255, 23, 23, 23),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PurchaseImporFormPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildAnimatedCard(
                    index: 2,
                    icon: Icons.receipt_long_outlined,
                    title: "Seleksi Pemasok",
                    subtitle: "Input seleksi pemasok baru",
                    color: const Color.fromARGB(255, 33, 33, 33),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SeleksiPemasokPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: _MenuCard(
          icon: icon,
          title: title,
          subtitle: subtitle,
          color: color,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _MenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 13,
                              color: Color(0xFF636E72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: const Color(0xFFB2BEC3),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
