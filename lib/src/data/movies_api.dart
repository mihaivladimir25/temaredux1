import 'dart:convert';

import 'package:tema/src/models/movie.dart';
import 'package:http/src/models/movie.dart';

class MovieApi{
  final String _apiUrl;
  final Client _client;


  Future<List<Movie>> getMovies() async {

    final Uri uri = Uri.parse('$_apiUrl/list_movies.json');
    final Response response = await _client.get(uri);

    if(response.statusCode >=300){
      throw StateError(response.body);
    }

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;

    return movies.map((dynamic json) => Movie.fromJson(json)).toList();
  }

}