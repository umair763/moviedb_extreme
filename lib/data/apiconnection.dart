import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchLatestMovies() async {
  final response = await http.get(
    Uri.parse('http://www.omdbapi.com/?s=movie&apikey=770267f9'),
  );

  if (response.statusCode == 200) {
    List searchResults = json.decode(response.body)['Search'];
    List detailedMovies = [];

    for (var movie in searchResults) {
      final movieDetailsResponse = await http.get(
        Uri.parse('http://www.omdbapi.com/?i=${movie['imdbID']}&apikey=770267f9'),
      );
      if (movieDetailsResponse.statusCode == 200) {
        detailedMovies.add(json.decode(movieDetailsResponse.body));
      }
    }
    return detailedMovies;
  } else {
    throw Exception('Failed to load latest movies');
  }

}

class Apicategories {
  final String baseUrl = 'http://www.omdbapi.com/';
  final String apiKey = '770267f9';

  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl?s=$query&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['Response'] == 'True') {
        List movies = jsonResponse['Search'];
        List<Movie> detailedMovies = [];

        for (var movie in movies) {
          final movieDetailsResponse = await http.get(
            Uri.parse('$baseUrl?i=${movie['imdbID']}&apikey=$apiKey'),
          );
          if (movieDetailsResponse.statusCode == 200) {
            detailedMovies.add(Movie.fromJson(json.decode(movieDetailsResponse.body)));
          }
        }
        return detailedMovies;
      } else {
        throw Exception('No movies found');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class Movie {
  final String id;
  final String title;
  final String poster;
  final String year;
  final String plot;
  final String rating;
  final String genres;

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.year,
    required this.plot,
    required this.rating,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'],
      title: json['Title'],
      poster: json['Poster'],
      year: json['Year'],
      plot: json['Plot'],
      rating: json['imdbRating'],
      genres: json['Genre'],
    );
  }
}

