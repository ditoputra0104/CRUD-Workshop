import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'workshopDetail.dart';

class WorkshopNonAcademic extends StatefulWidget {
  const WorkshopNonAcademic({super.key});

  @override
  State<WorkshopNonAcademic> createState() => _WorkshopNonAcademicState();
}

class _WorkshopNonAcademicState extends State<WorkshopNonAcademic> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("SmartComp"),
      //   backgroundColor: Colors.deepPurple.shade200,
      //   actions: const [
      //     Icon(Icons.shopping_cart),
      //     SizedBox(width: 8),
      //     Icon(Icons.notifications),
      //     SizedBox(width: 8),
      //     Icon(Icons.person),
      //     SizedBox(width: 16),
      //   ],
      // ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) =>
                  setState(() => searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search for competition or workshop',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Recommended Workshop and Competition from us\nAll the skills you need in one place",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          // Filter buttons (optional visual only)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                    label: const Text("Academic"),
                    selected: false,
                    onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(
                    label: const Text("Non-Academic"),
                    selected: true,
                    onSelected: (_) {}),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // GridView for workshop cards
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workshops')
                  .where('category', isEqualTo: 'non-academic')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final data = snapshot.data!.docs
                    .where((doc) => doc['title']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery))
                    .toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final doc = data[index];
                    final title = doc['title'] ?? '';
                    final image = doc['image'] ?? '';
                    final type = doc['category'] ?? '';
                    final price = doc['price'] ?? 0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkshopDetail(
                              docId: doc.id,
                              workshop: doc.data() as Map<String, dynamic>,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 60),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WorkshopDetail(
                                        docId: doc.id,
                                        workshop:
                                            doc.data() as Map<String, dynamic>,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade100,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                child: const Text("Jelajahi",
                                    style: TextStyle(color: Colors.deepPurple)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
