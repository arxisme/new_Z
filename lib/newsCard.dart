import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String author;
  final String website;
  final int points;
  final String url;

  const NewsCard({super.key, 
    required this.title,
    required this.author,
    required this.website,
    required this.points,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 7, 22, 54),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        '$author • $website',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 230, 226, 226),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$points',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'points',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 211, 204, 204),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
