import 'package:flutter/material.dart';
import 'package:moviesearchapp/data/apiconnection.dart';
import 'package:moviesearchapp/ui/screens/moviedetailspage.dart';
import 'package:moviesearchapp/ui/specialwidgets/customchip.dart';
import 'package:moviesearchapp/ui/specialwidgets/movieinfocard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  late Apicategories apiService;
  List<Movie> searchResults = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'ALL';

  @override
  void initState() {
    super.initState();
    apiService = Apicategories();
  }

  void _searchMovies(String query) async {
    if (query.isNotEmpty) {
      try {
        var results = await apiService.fetchMovies(query);
        setState(() {
          searchResults = results;
        });
      } catch (e) {
        setState(() {
          searchResults = [];
        });
      }
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _searchMovies(category == 'ALL' ? 'movie' : category.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Icon(Icons.search_sharp),
        ),
        iconTheme: const IconThemeData(color: Colors.amber, size: 40),
        backgroundColor: Colors.black,
        title: RichText(
          text: const TextSpan(
            text: "Search",
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onSubmitted: (query) => _searchMovies(query),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[850],
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomChip(
                    categories: const [
                      'ALL',
                      'ACTION',
                      'DRAMA',
                      'COMEDY',
                      'ADVENTURE',
                      'ANIMATION',
                      'HISTORY',
                      'HORROR',
                      'WESTERN',
                      'ROMANCE'
                    ],
                    onCategorySelected: _onCategorySelected,
                    selectedCategory: selectedCategory,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  'Search results (${searchResults.length})',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  var movie = searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Movieinfocard(
                      title: movie.title,
                      rating: movie.rating,
                      genres: movie.genres,
                      plot: movie.plot,
                      posterUrl: movie.poster,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Moviedetailspage(
                              id: movie.id,
                              title: movie.title,
                              rating: movie.rating,
                              genres: movie.genres,
                              plot: movie.plot,
                              posterUrl: movie.poster,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
