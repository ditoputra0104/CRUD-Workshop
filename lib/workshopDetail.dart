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
    final String title = workshop['title'] ?? '';
    final String openRegist = workshop['open_regist'] ?? '';
    final String closeRegist = workshop['close_regist'] ?? '';
    final String competitionDay = workshop['competition_day'] ?? '';
    final String prize1 = workshop['prize_1'] ?? '';
    final String prize2 = workshop['prize_2'] ?? '';
    final String prize3 = workshop['prize_3'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple.shade300,
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Timeline",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _timelineItem(Icons.circle, "Opens: $openRegist"),
                  _timelineItem(Icons.circle_outlined, "Closes: $closeRegist"),
                  _timelineItem(Icons.circle_outlined,
                      "Competition Day: $competitionDay"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Prizes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _prizeCard("1st Place", prize1),
                _prizeCard("2nd Place", prize2),
                _prizeCard("3rd Place", prize3),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Requirements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _requirementItem("Active university student status"),
            _requirementItem("Complete registration before deadline"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('cart').add({
                        'name': title,
                        'type': workshop['type'] ?? '',
                        'price': workshop['price'] ?? '',
                        'image': workshop['image'] ?? '',
                        'date': competitionDay,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to cart")),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPaymentPage(
                            workshopTitle: title,
                            imageUrl: workshop['image'] ?? '',
                            type: workshop['type'] ?? '',
                            price: (workshop['price'] ?? '').toString(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _prizeCard(String place, String amount) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
          ),
          child: Column(
            children: [
              const Icon(Icons.emoji_events, color: Colors.deepPurple),
              const SizedBox(height: 4),
              Text(place, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Rp", style: TextStyle(color: Colors.green)),
              Text(
                amount,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _requirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
