import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/components/draw.dart';

class Results extends StatefulWidget {
  final String documentId;
  const Results({required this.documentId, super.key});
  @override
  State<Results> createState() => ResultsState();
}

class ResultsState extends State<Results> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureSnapshot;
  int currentImageIndex = 0;
  @override
  void initState() {
    super.initState();
    futureSnapshot = FirebaseFirestore.instance
        .collection('submissions')
        .doc(widget.documentId)
        .get();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: futureSnapshot,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error:  ${snapshot.error}'));
        } else {
          final data = snapshot.data?.data() ?? {};
          final imageUrls = [...?data['imageUrls']].cast<String>();

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 25),
                  ImageDisplayContainer(
                    imageUrls: imageUrls,
                    currentImageIndex: currentImageIndex,
                    onPrevious: () {
                      if (currentImageIndex > 0) {
                        setState(
                          () => currentImageIndex--,
                        );
                      }
                    },
                    onNext: () {
                      if (currentImageIndex < imageUrls.length - 1) {
                        setState(
                          () => currentImageIndex++,
                        );
                      }
                    },
                    date: (data['date'] as Timestamp?)?.toDate(),
                    feedback: data['feedback'],
                    mistakes: data['mistakes'],
                  ),
                ],
              ),
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
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      color: const Color(0xff000054),
      child: Center(
        child: Column(
          children: [
            Text(
              'Results',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ImageDisplayContainer extends StatelessWidget {
  final List<String> imageUrls;
  final int currentImageIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final DateTime? date;
  final dynamic feedback;
  final dynamic mistakes;

  const ImageDisplayContainer({
    super.key,
    required this.imageUrls,
    required this.currentImageIndex,
    required this.onPrevious,
    required this.onNext,
    this.date,
    this.feedback,
    this.mistakes,
  });
  @override
  Widget build(BuildContext context) {
    List<Widget> feedbackWidgets = _buildFeedbackList();
    int mistakes = feedback is List ? feedback.length : 0;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff000054),
          width: 3.0,
        ),
      ),
      child: Column(
        children: [
          _buildImageNavigationRow(),
          if (imageUrls.isNotEmpty)
            Image.network(imageUrls[currentImageIndex])
          else
            const SizedBox.shrink(),
          const SizedBox(height: 10),
          Text(
            'Submitted on: ${date != null ? DateFormat('dd/MM/yy').format(date!) : 'N/A'}',
          ),
          Text(
            'Mistakes: $mistakes',
          ),
          ...feedbackWidgets,
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/mark');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffCF4520),
            ),
            child: const Text(
              'Mark a new response',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeedbackList() {
    if (feedback == null) {
      return [const Text('Feedback: No text detected')];
    }
    // mistake is the iterable, map is the function instantiating the iteration through the feedback array
    return (feedback as List).map(
      (mistake) {
        final incorrect = mistake['mistake'];
        final correct = mistake['correction'];
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: '- ',
                style: TextStyle(
                  color: Color(0xff000054),
                  fontSize: 18,
                  fontFamily: 'Overlock',
                  fontWeight: FontWeight.bold, 
                ),
              ),
              TextSpan(
                text: '$incorrect',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontFamily: 'Overlock',
                ),
              ),
              const TextSpan(
                text: ' -> ',
                style: TextStyle(
                  color: Color(0xff000054),
                  fontSize: 18,
                  fontFamily: 'Overlock',
                ),
              ),
              TextSpan(
                text: '$correct',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontFamily: 'Overlock',
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  Widget _buildImageNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Image ${currentImageIndex + 1} of ${imageUrls.length}'),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffCF4520),
                size: 18,
              ),
              onPressed: onPrevious,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xffCF4520),
                size: 18,
              ),
              onPressed: onNext,
            ),
          ],
        ),
      ],
    );
  }
}
