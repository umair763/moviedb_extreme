import 'package:flutter/material.dart';
import 'package:moviesearchapp/ui/screens/discover.dart';
import 'package:moviesearchapp/ui/specialwidgets/movieinfocard.dart';
import 'package:moviesearchapp/ui/specialwidgets/ratingcard.dart';
import 'package:moviesearchapp/ui/screens/moviedetailspage.dart';


class Mainpage extends StatefulWidget {
  final List movies;

  const Mainpage({super.key, required this.movies});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  List bestMovies = [];
  List newestMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchBestMovies();
    _fetchNewestMovies();
  }

  void _fetchBestMovies() {
    // Sort movies by imdbRating in descending order
    widget.movies.sort((a, b) {
      double ratingA = double.tryParse(a["imdbRating"]) ?? 0.0;
      double ratingB = double.tryParse(b["imdbRating"]) ?? 0.0;
      return ratingB.compareTo(ratingA); // Descending order
    });

    // Take the top 5 movies
    bestMovies = widget.movies.take(5).toList();
  }

  void _fetchNewestMovies() {
    // Sort movies by year in descending order
    widget.movies.sort((a, b) {
      int yearA = int.tryParse(a["Year"]) ?? 0;
      int yearB = int.tryParse(b["Year"]) ?? 0;
      return yearB.compareTo(yearA); // Descending order by year
    });
    newestMovies = widget.movies.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP FIVE
              RichText(
                text: const TextSpan(
                  text: "Top Five",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ".",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // RATING CARD
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bestMovies.map((mov) {
                    return Row(
                      children: [
                        RatingCard(
                          title: mov['Title'],
                          rating: mov['imdbRating'],
                          posterUrl: mov['Poster'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Moviedetailspage(
                                  id: mov['imdbID'],
                                  title: mov['Title'],
                                  rating: mov['imdbRating'],
                                  genres: mov['Genre'],
                                  plot: mov['Plot'],
                                  posterUrl: mov['Poster'],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              // LATEST
              Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Latest",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: ".",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Discover()),
                      );
                    },
                    child: const Text(
                      "SEE MORE",
                      style: TextStyle(color: Colors.amber, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: newestMovies.map((movie) {
                  return Column(
                    children: [
                      Movieinfocard(
                        title: movie['Title'],
                        rating: movie['imdbRating'],
                        genres: movie['Genre'],
                        plot: movie['Plot'],
                        posterUrl: movie['Poster'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Moviedetailspage(
                                id: movie['imdbID'],
                                title: movie['Title'],
                                rating: movie['imdbRating'],
                                genres: movie['Genre'],
                                plot: movie['Plot'],
                                posterUrl: movie['Poster'],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
