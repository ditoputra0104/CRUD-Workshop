import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminPaymentPage extends StatelessWidget {
  const AdminPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Payment Records'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading payments'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No payments found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateFormat('dd MMM yyyy – HH:mm').format(timestamp.toDate())
                  : '-';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text(data['workshopTitle'] ?? 'Unknown Workshop'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${data['name'] ?? '-'}"),
                      Text("Phone: ${data['phone'] ?? '-'}"),
                      Text("Method: ${data['paymentMethod'] ?? '-'}"),
                      Text("Type: ${data['type'] ?? '-'}"),
                      Text("Paid: Rp${data['price'] ?? '0'}"),
                      Text("Date: $formattedDate"),
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
