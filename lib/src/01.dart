import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'models/movie.dart';

// ignore_for_file: file_names
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Movie> _movies = <Movie>[];
  
  @override
  Widget build(BuildContext context) {
    return MoviesProvider(
      movies: _movies,
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  // 1. then/catchError
  // 2. async/await
  // 3. Stream
  // 4. StreamController(generator)/Completer
  // 5. Isolates
  Future<void> _getMovies() async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'yts.mx',
      pathSegments: <String>['api', 'v2', 'list_movies.json'],
      queryParameters: <String, String>{
        'limit': '20',
        'page': '1',
      },
    );

    final Response response = await get(url);
    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;
    
    setState(() {
      for (final dynamic movie in movies) {
        MoviesProvider.of(context).add(Movie.fromJson(movie as Map<String, dynamic>));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.699,
        ),
        itemCount: MoviesProvider.of(context).movies.length,
        itemBuilder: (BuildContext context, int index) {
          final Movie movie = MoviesProvider.of(context).movies[index];

          return GridTile(
            child: Image.network(
              movie.mediumCoverImage,
              fit: BoxFit.cover,
            ),
            footer: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: <Color>[
                    Colors.black26,
                    Colors.black,
                  ],
                ),
              ),
              child: GridTileBar(
                title: Text(movie.title),
                subtitle: Text('${movie.year}'),
                trailing: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      size: 40.0,
                      color: Colors.amber,
                    ),
                    Text(
                      '${movie.rating}',
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MoviesProvider extends InheritedWidget {
  const MoviesProvider({
    Key key,
    @required Widget child,
    required this.movies,
  })  : assert(child != null),
        super(key: key, child: child);

  final List<Movie> movies;

  void add(Movie movie){
    movies.add(movie);
  }
  
  static MoviesProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MoviesProvider>();
  }

  @override
  bool updateShouldNotify(MoviesProvider old) {
    return false;
  }
}