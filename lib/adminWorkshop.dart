import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminWorkshopPage extends StatefulWidget {
  const AdminWorkshopPage({Key? key}) : super(key: key);

  @override
  State<AdminWorkshopPage> createState() => _AdminWorkshopPageState();
}

class _AdminWorkshopPageState extends State<AdminWorkshopPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String _selectedCategory = 'academic';
  final List<String> _categories = ['academic', 'non-academic'];

  Future<void> _addWorkshop() async {
    try {
      await FirebaseFirestore.instance.collection('workshops').add({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'price': int.tryParse(_priceController.text) ?? 0,
        'image': _imageController.text.trim(),
        'category': _selectedCategory,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workshop berhasil ditambahkan")),
      );

      _titleController.clear();
      _descController.clear();
      _priceController.clear();
      _imageController.clear();
      setState(() {
        _selectedCategory = 'academic';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Workshop"),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Workshop Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: "Image URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWorkshop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Add Workshop"),
            )
          ],
        ),
      ),
    );
  }
}
