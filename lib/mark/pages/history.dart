import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './results.dart';
import '../../home/components/draw.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            color: const Color(0xff000054),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Click on a tile to see past results.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('submissions')
                  .where('username', isEqualTo: user.email)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Something went wrong: ${snapshot.error}'),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      SizedBox(height: 10),
                      CircularProgressIndicator(
                        color: Color(0xffCF4520),
                      ),
                    ],
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(height: 10),
                      Text('No recent submissions found'),
                    ],
                  );
                }
                // adding space between edge of screen and tile
                return Padding(
                  padding: const EdgeInsets.all(20),
                  // creating a list of tiles
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    // required argument specifying length of the list
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      // extracting each specific document (or snapshot)
                      var doc = snapshot.data!.docs[index];
                      // dictionary of all required values
                      var data = doc.data() as Map<String, dynamic>;
                      // formatting the date as 'Monday 1st January'
                      var date = (data['date'] as Timestamp?)?.toDate();
                      // selection to ensure the date field isn't empty
                      var formattedDate = date != null
                          ? DateFormat('EEEE d\'th\' MMMM').format(date)
                          : 'N/A';
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color(0xffCF4520),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xff000054),
                            child: Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Results(
                                  documentId: doc.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff000054),
        elevation: 0,
      ),
      drawer: Draw(
        onSignOut: signUserOut,
      ),
    );
  }
}