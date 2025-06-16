import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addPayment.dart';

class WorkshopDetail extends StatelessWidget {
  final Map<String, dynamic> workshop;
  final String docId;

  const WorkshopDetail({
    Key? key,
    required this.workshop,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = workshop['title'] ?? '';
    final type = workshop['category'] ?? '';
    final price = workshop['price'] ?? 0;
    final image = workshop['image'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(image,
                height: 150,
                errorBuilder: (_, __, ___) => const Icon(Icons.image)),
            const SizedBox(height: 16),
            Text("Type: $type"),
            Text("Price: Rp $price"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Add to Cart"),
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('cart').add({
                        'name': title,
                        'type': type,
                        'price': price,
                        'image': image,
                        'date': Timestamp.now(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to cart!")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment),
                    label: const Text("Regist Workshop"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPaymentPage(
                            workshopTitle: title,
                            imageUrl: image,
                            type: type,
                            price: price.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
