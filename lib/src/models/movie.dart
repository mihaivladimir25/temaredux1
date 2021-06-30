library movie;

import 'package:built_value/serializer.dart';

part 'movie.g.dart';

abstract class Movie implements Built<Movie, MovieBuilder>{
  factory Movie([void Function(MovieBuilder) updates]) = _$Movie;

  factory Movie.fromJson(dynamic json){
    return serializers.deserializeWith(serializer, json) as Movie;
  }

  Movie._();

  String get title;

  static Serializer<Movie> get serializer => _$movieSerializer;
}