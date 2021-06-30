import 'package:tema/src/models/movie.dart';
import 'package:tema/src/data/movies_api.dart';
import 'package:redux/redux.dart';
import 'package:tema/src/actions/get_movies.dart';

class AppMiddleware{
  const AppMiddleware({required MoviesApi moviesApi}) : _moviesApi = moviesApi;

  final MovieApi _moviesApi;

  List<Middleware> get middleware{
    return <Middleware>[
      TypedMiddleware<AppState, GetMovies>(_getMovies)
    ]
  }

  Future<void> _getMovies(Store<AppState> store, GetMovies action, NextDispatcher next) async {
      next(action);

      try{
        final List<Movie> movies = await _moviesApi.getMovies();
        store.dispatch(SetMoviesError(movies));
      }catch(error){
        store.dispatch(SetMoviesError(error));
      }
    }

  }
}