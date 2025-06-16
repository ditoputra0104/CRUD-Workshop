import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPaymentPage extends StatefulWidget {
  final String workshopTitle;
  final String imageUrl;
  final String price;
  final String type;

  const AddPaymentPage({
    Key? key,
    required this.workshopTitle,
    required this.imageUrl,
    required this.price,
    required this.type,
  }) : super(key: key);

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = '';

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('payments').add({
          'workshopTitle': widget.workshopTitle,
          'image': widget.imageUrl,
          'type': widget.type,
          'price': widget.price,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'paymentMethod': _paymentMethod,
          'timestamp': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment submitted successfully!")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workshop: ${widget.workshopTitle}",
                style: const TextStyle(fontSize: 18)),
            Text("Type: ${widget.type}"),
            Text("Price: Rp ${widget.price}"),
            const Divider(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod.isNotEmpty ? _paymentMethod : null,
                    decoration:
                        const InputDecoration(labelText: 'Payment Method'),
                    items: const [
                      DropdownMenuItem(
                          value: 'transfer', child: Text("Bank Transfer")),
                      DropdownMenuItem(
                          value: 'ewallet', child: Text("E-Wallet")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Choose one' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text("Proceed to Payment"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
