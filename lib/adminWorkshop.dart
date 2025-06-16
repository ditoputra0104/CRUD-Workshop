import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminWorkshopPage extends StatefulWidget {
  const AdminWorkshopPage({Key? key}) : super(key: key);

  @override
  State<AdminWorkshopPage> createState() => _AdminWorkshopPageState();
}

class _AdminWorkshopPageState extends State<AdminWorkshopPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _openRegistController = TextEditingController();
  final _closeRegistController = TextEditingController();
  final _competitionDayController = TextEditingController();
  final _prize1Controller = TextEditingController();
  final _prize2Controller = TextEditingController();
  final _prize3Controller = TextEditingController();

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
        'open_regist': _openRegistController.text.trim(),
        'close_regist': _closeRegistController.text.trim(),
        'competition_day': _competitionDayController.text.trim(),
        'prize_1': _prize1Controller.text.trim(),
        'prize_2': _prize2Controller.text.trim(),
        'prize_3': _prize3Controller.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workshop berhasil ditambahkan")),
      );

      _titleController.clear();
      _descController.clear();
      _priceController.clear();
      _imageController.clear();
      _openRegistController.clear();
      _closeRegistController.clear();
      _competitionDayController.clear();
      _prize1Controller.clear();
      _prize2Controller.clear();
      _prize3Controller.clear();

      setState(() {
        _selectedCategory = 'academic';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? inputType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
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
            _buildTextField("Workshop Title", _titleController),
            _buildTextField("Description", _descController),
            _buildTextField("Price", _priceController,
                inputType: TextInputType.number),
            _buildTextField("Image URL", _imageController),
            _buildTextField("Open Registration", _openRegistController),
            _buildTextField("Close Registration", _closeRegistController),
            _buildTextField("Competition Day", _competitionDayController),
            _buildTextField("Prize Juara 1", _prize1Controller),
            _buildTextField("Prize Juara 2", _prize2Controller),
            _buildTextField("Prize Juara 3", _prize3Controller),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
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
