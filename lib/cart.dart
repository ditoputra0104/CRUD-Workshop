import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addPayment.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _deleteCartItem(String docId) {
    FirebaseFirestore.instance.collection('cart').doc(docId).delete();
  }

  void _checkout(BuildContext context, Map<String, dynamic> workshop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPaymentPage(
          workshopTitle: workshop['name'] ?? '',
          imageUrl: workshop['image'] ?? '',
          type: workshop['type'] ?? '',
          price: workshop['price'].toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.purple[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading cart.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final item = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        item['image'] ?? '',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Type: ${item['type'] ?? ''}"),
                      Text("Price: Rp ${item['price'] ?? ''}"),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text("Delete",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => _deleteCartItem(doc.id),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.payment),
                            label: const Text("Checkout"),
                            onPressed: () => _checkout(context, item),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
