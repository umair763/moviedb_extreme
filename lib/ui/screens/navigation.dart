import 'package:flutter/material.dart';
import 'package:moviesearchapp/ui/screens/mainpage.dart';
import 'package:moviesearchapp/ui/screens/bookmarkspage.dart';
import 'package:moviesearchapp/ui/screens/searchpage.dart';
import 'package:moviesearchapp/data/apiconnection.dart';


class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;
  List movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    List fetchedMovies = await fetchLatestMovies();
    setState(() {
      movies = fetchedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Mainpage(movies: movies),
      SearchPage(),
      const Bookmarkspage(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: selectedIndex == 0 ? Colors.amber : Colors.white,
              size: selectedIndex == 0 ? 35 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: selectedIndex == 1 ? Colors.amber : Colors.white,
              size: selectedIndex == 1 ? 35 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              color: selectedIndex == 2 ? Colors.amber : Colors.white,
              size: selectedIndex == 2 ? 35 : 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
