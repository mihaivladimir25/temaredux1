import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';
import 'package:tema/src/actions/get_movies.dart';
import 'package:tema/src/models/app_state.dart';
import 'package:tema/src/models/movie.dart';

Reducer<AppState> reducer = combineReducers(<Reducer<AppState>>[
  TypedReducer<AppState, SetMoviesSuccessful>(_getMoviesSuccessful),
]);

AppState reducer(dynamic action, AppState state){
  if(action is GetMoviesSuccessful){
    return state.rebuild((AppStateBuilder b){
      b.movies = ListBuilder<Movie>(action.movies);
    });
  }

  return state;
}

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action){

}