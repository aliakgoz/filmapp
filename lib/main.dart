import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Movie Model
class Movie {
  final String title;
  final String description;
  final String director;
  final String year;

  Movie({
    required this.title,
    required this.description,
    required this.director,
    required this.year,
  });
}

// Fake Database
class FakeDatabase {
  static List<Movie> movies = [
    Movie(title: 'Inception', description: 'A thief who steals corporate secrets...', director: 'Christopher Nolan', year: '2010'),
    Movie(title: 'The Matrix', description: 'A computer hacker learns...', director: 'Lana Wachowski, Lilly Wachowski', year: '1999'),
    Movie(title: 'Interstellar', description: 'A team of explorers travel through a wormhole...', director: 'Christopher Nolan', year: '2014'),
    Movie(title: 'Fight Club', description: 'An insomniac office worker...', director: 'David Fincher', year: '1999'),
    Movie(title: 'Pulp Fiction', description: 'The lives of two mob hitmen...', director: 'Quentin Tarantino', year: '1994'),
    Movie(title: 'The Dark Knight', description: 'When the menace known as the Joker...', director: 'Christopher Nolan', year: '2008'),
    Movie(title: 'Forrest Gump', description: 'The presidencies of Kennedy and Johnson...', director: 'Robert Zemeckis', year: '1994'),
    Movie(title: 'The Shawshank Redemption', description: 'Two imprisoned men bond over...', director: 'Frank Darabont', year: '1994'),
    Movie(title: 'The Godfather', description: 'The aging patriarch of an organized crime dynasty...', director: 'Francis Ford Coppola', year: '1972'),
    Movie(title: 'Gladiator', description: 'A former Roman General sets out to exact vengeance...', director: 'Ridley Scott', year: '2000'),
  ];

  static List<Movie> searchMovies(String query) {
    return movies.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

// Movie Provider
class MovieProvider with ChangeNotifier {
  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  Movie? _selectedMovie;
  Movie? get selectedMovie => _selectedMovie;

  void searchMovies(String query) {
    _searchResults = FakeDatabase.searchMovies(query);
    notifyListeners();
  }

  void selectMovie(Movie movie) {
    _selectedMovie = movie;
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movie App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Search'),
              Tab(text: 'Watchlist'),
              Tab(text: 'Watched'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchTab(),
            WatchlistTab(),
            WatchedTab(),
          ],
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search for a movie',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
            },
          ),
        ),
        Expanded(
          child: Consumer<MovieProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.searchResults.length,
                itemBuilder: (context, index) {
                  final movie = provider.searchResults[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.director),
                    onTap: () {
                      provider.selectMovie(movie);
                    },
                  );
                },
              );
            },
          ),
        ),
        Consumer<MovieProvider>(
          builder: (context, provider, child) {
            if (provider.selectedMovie == null) {
              return Container();
            }
            final movie = provider.selectedMovie!;
            return Column(
              children: [
                Text('Title: ${movie.title}'),
                Text('Director: ${movie.director}'),
                Text('Year: ${movie.year}'),
                Text('Description: ${movie.description}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Watched')),
                    ElevatedButton(onPressed: () {}, child: Text('Watchlist')),
                    ElevatedButton(onPressed: () {}, child: Text('Rate')),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class WatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Watchlist Tab'),
    );
  }
}

class WatchedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Watched Tab'),
    );
  }
}
