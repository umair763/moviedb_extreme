import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class Movieinfocard extends StatefulWidget {
  final String title;
  final String rating;
  final String genres;
  final String plot;
  final String posterUrl;
  final VoidCallback onTap; // Add this line

  const Movieinfocard({
    super.key,
    required this.title,
    required this.rating,
    required this.genres,
    required this.plot,
    required this.posterUrl,
    required this.onTap, // Add this line
  });

  @override
  State<Movieinfocard> createState() => _MovieinfocardState();
}

class _MovieinfocardState extends State<Movieinfocard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap, // Use the callback
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: deviceWidth / 2.2,
                height: deviceHeight / 2.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                  image: DecorationImage(
                    image: NetworkImage(widget.posterUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isBookmarked = !isBookmarked;
                    });
                  },
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline_rounded,
                    color: isBookmarked ? Colors.amber : Colors.white,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      widget.rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    ...List.generate(5, (index) {
                      double starRating = double.tryParse(widget.rating) ?? 0.0;
                      return Icon(
                        index < starRating / 2 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                Text(widget.genres,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
                const SizedBox(height: 10),
                ReadMoreText(
                  widget.plot,
                  trimLines: 2,
                  colorClickableText: Colors.amber,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  style: const TextStyle(color: Colors.grey),
                  moreStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
