import 'package:flutter/material.dart';

class RatingCard extends StatefulWidget {
  final String title;
  final String rating;
  final String posterUrl;
  final VoidCallback onTap;

  const RatingCard({
    super.key,
    required this.title,
    required this.rating,
    required this.posterUrl,
    required this.onTap,

  });

  @override
  RatingCardState createState() => RatingCardState();
}

class RatingCardState extends State<RatingCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: deviceWidth / 1.18,
                height: deviceHeight / 3.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.posterUrl),
                  ),
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
        const SizedBox(height: 4), // Resim ve rating arasında boşluk
        Column(
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
      ],
    );
  }
}
