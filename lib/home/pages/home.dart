import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/draw.dart';
import '../components/tile.dart';
import '../../mark/pages/results.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed('/lor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff000054),
        elevation: 0,
      ),
      drawer: Draw(
        onSignOut: signUserOut,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: const Color(0xff000054),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Home',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Actions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tile(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xff000054),
                      size: 50,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/mark'),
                    text: 'Mark',
                  ),
                  Tile(
                    icon: const Icon(
                      Icons.history,
                      color: Color(0xff000054),
                      size: 50,
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/history'),
                    text: 'History',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Recent Submissions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('submissions')
                  .where('username', isEqualTo: user.email)
                  .orderBy('date', descending: true)
                  .limit(5)
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
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      var date = (data['date'] as Timestamp?)?.toDate();
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
            )
          ],
        ),
      ),
    );
  }
}
