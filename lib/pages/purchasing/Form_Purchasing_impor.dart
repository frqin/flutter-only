import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

class PurchaseImporFormPage extends StatefulWidget {
  const PurchaseImporFormPage({super.key});

  @override
  State<PurchaseImporFormPage> createState() => _PurchaseImporFormPageState();
}

class _PurchaseImporFormPageState extends State<PurchaseImporFormPage>
    with SingleTickerProviderStateMixin {
  final orderNumber = TextEditingController();
  final date = TextEditingController();
  final supplier = TextEditingController();

  // Item list
  List<OrderItem> items = [OrderItem()];

  File? directorSignature;
  File? supplierSignature;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    orderNumber.dispose();
    date.dispose();
    supplier.dispose();
    super.dispose();
  }

  Future<void> pickSignature(bool isDirector) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (isDirector) {
          directorSignature = File(picked.path);
        } else {
          supplierSignature = File(picked.path);
        }
      });
    }
  }

  void addItem() {
    setState(() {
      items.add(OrderItem());
    });
  }

  void removeItem(int index) {
    if (items.length > 1) {
      setState(() {
        items.removeAt(index);
      });
    }
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      final qty = double.tryParse(item.quantity.text) ?? 0;
      final price = double.tryParse(item.price.text) ?? 0;
      total += qty * price;
    }
    return total;
  }

  Widget buildHeaderInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: "InriaSans",
            fontSize: 13,
            color: Colors.black54,
          ),
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget buildItemRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Item ${index + 1}",
                style: const TextStyle(
                  fontFamily: "InriaSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (items.length > 1)
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  color: Colors.black,
                  onPressed: () => removeItem(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: items[index].description,
            decoration: InputDecoration(
              labelText: "Description & Specification",
              labelStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: items[index].quantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Qty",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: items[index].unit,
                  decoration: InputDecoration(
                    labelText: "Unit",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: items[index].price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price (Rp)",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSignatureBox(String title, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'InriaSans',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1.5),
            ),
            child: file == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(LucideIcons.upload, color: Colors.black38, size: 24),
                      SizedBox(height: 4),
                      Text(
                        "Tap to upload ",
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: 'InriaSans',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Purchase Impor Form",
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER SECTION
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    buildHeaderInput(
                      label: "Order Sheet No.",
                      controller: orderNumber,
                      icon: LucideIcons.fileText,
                    ),
                    buildHeaderInput(
                      label: "Dated",
                      controller: date,
                      icon: LucideIcons.calendar,
                    ),
                    buildHeaderInput(
                      label: "Supplier",
                      controller: supplier,
                      icon: LucideIcons.building,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ITEMS SECTION
              Row(
                children: [
                  const Text(
                    "Order Items",
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: addItem,
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text("Add Item"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontFamily: 'InriaSans'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...List.generate(items.length, (index) => buildItemRow(index)),

              // TOTAL
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF2F2F2F),

                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'InriaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Rp ${calculateTotal().toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'InriaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SIGNATURES
              const Text(
                "Approvals",
                style: TextStyle(
                  fontFamily: 'InriaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: buildSignatureBox(
                      "Director",
                      directorSignature,
                      () => pickSignature(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 24),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Purchase Impor saved successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2F2F2F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Save Purchase Impor Order",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'InriaSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem {
  final description = TextEditingController();
  final quantity = TextEditingController();
  final unit = TextEditingController();
  final price = TextEditingController();
}
