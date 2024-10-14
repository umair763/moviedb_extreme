import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:hive/hive.dart';

class Moviedetailspage extends StatefulWidget {
  final String title;
  final String rating;
  final String genres;
  final String plot;
  final String posterUrl;
  final String id;

  const Moviedetailspage({
    super.key,
    required this.title,
    required this.rating,
    required this.genres,
    required this.plot,
    required this.posterUrl,
    required this.id,
  });

  @override
  State<Moviedetailspage> createState() => _MoviedetailspageState();
}

class _MoviedetailspageState extends State<Moviedetailspage> {
  var isBookmarked = false;
  final Box bookmarksBox = Hive.box('bookmarks');

  @override
  void initState() {
    super.initState();
    List bookmarkedMovies = bookmarksBox.get('movies', defaultValue: []);
    isBookmarked = bookmarkedMovies.any((movie) => movie['id'] == widget.id);
  }

  void toggleBookmark() {
    List bookmarkedMovies = bookmarksBox.get('movies', defaultValue: []);
    if (isBookmarked) {
      bookmarkedMovies.removeWhere((movie) => movie['id'] == widget.id);
    } else {
      bookmarkedMovies.add({
        'id': widget.id,
        'title': widget.title,
        'rating': widget.rating,
        'genres': widget.genres,
        'plot': widget.plot,
        'posterUrl': widget.posterUrl,
      });
    }
    bookmarksBox.put('movies', bookmarkedMovies);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }


  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrlString(url.toString(), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        actions: [
          IconButton(
            alignment: Alignment.topRight,
            iconSize: 40,
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isBookmarked ? Colors.amber : Colors.white,
            ),
            onPressed: toggleBookmark,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Image.network(
            widget.posterUrl,
            fit: BoxFit.cover,
            width: deviceWidth,
            height: deviceHeight / 2,
          ),
          SizedBox(
            height: deviceHeight,
            width: deviceWidth,
          ),
          // Black gradient
          Positioned(
            bottom: 0,
            child: Container(
              height: deviceHeight / 2,
              width: deviceWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: deviceWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(5, (index) {
                        double starRating =
                            double.tryParse(widget.rating) ?? 0.0;
                        return Icon(
                          index < starRating / 2
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        );
                      }),
                    ],
                  ),
                  Text(
                    widget.genres,
                    style: const TextStyle(color: Colors.white),
                  ),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: deviceWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(Colors.amber),
                        shape:
                        WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _launchURL(
                            'https://www.imdb.com/title/${widget.id}'
                        ); // Ensure correct URL format
                      },
                      child: const Text(
                        "WATCH TRAILER",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
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
