import 'package:flutflix/api/api.dart';
import 'package:flutflix/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutflix/models/movie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutflix/screen/detail_screen.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<Movie>> allMovies;
  late List<Movie> displayedMovies = [];
  List<Movie> _searchResults = [];

  @override
  void initState() {
    super.initState();
    allMovies = _getAllMovies();
  }

  Future<List<Movie>> _getAllMovies() async {
    // Panggil API untuk mendapatkan data dari ketiga kategori
    List<Movie> trendingMovies = await Api().getTrendingMovies();
    List<Movie> topRatedMovies = await Api().getTopRateMovies();
    List<Movie> upcomingMovies = await Api().getUpcomingMovies();

    Map<String, Movie> uniqueMoviesMap = {};

    void addMoviesToMap(List<Movie> movies) {
      for (var movie in movies) {
        // Gunakan kombinasi atribut sebagai kunci
        final key = '${movie.title}_${movie.releaseDate}';
        uniqueMoviesMap[key] = movie;
      }
    }

    addMoviesToMap(trendingMovies);
    addMoviesToMap(topRatedMovies);
    addMoviesToMap(upcomingMovies);

    List<Movie> combinedMovies = uniqueMoviesMap.values.toList();
    combinedMovies.sort((a, b) => a.title.compareTo(b.title));

    return combinedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _performSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFF8CF4A),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: allMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Movie> allMoviesList = snapshot.data as List<Movie>;

                  if (allMoviesList.isNotEmpty) {
                    return _buildMovieCategory('All Movies', allMoviesList);
                  } else {
                    return Center(child: Text('No movies available.'));
                  }
                } else {
                  return Center(child: Text('No data available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCategory(String category, List<Movie> movies) {
    List<Movie> displayedMovies =
        _searchResults.isNotEmpty ? _searchResults : movies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedMovies.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gambar di samping kiri
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${Constants.imagePath}${displayedMovies[index].posterPath}',
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                            width:
                                8), // Jarak antara gambar dan informasi lainnya
                        // Informasi di sebelah kanan
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayedMovies[index].title,
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Release Date: ${displayedMovies[index].releaseDate}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Rating ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Text(
                                        ': ' +
                                            '${displayedMovies[index].voteAverage.toStringAsFixed(1)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }

  void _performSearch(String query) async {
    List<Movie> searchResults = [];

    if (query.isNotEmpty) {
      // Menunggu hasil dari Future<List<Movie>>
      List<Movie> allMoviesList = await _getAllMovies();

      // Menggunakan where pada list yang sudah diambil dari Future
      searchResults = allMoviesList
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      // Menunggu hasil dari Future<List<Movie>>
      searchResults = await _getAllMovies();
    }

    // Memperbarui state dengan hasil pencarian
    setState(() {
      _searchResults = searchResults;
    });
  }
}
