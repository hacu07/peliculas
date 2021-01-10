

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:http/http.dart' as http;

class MoviesProvider{
  String _apiKey = '4a2991b5919a30f27529a76cc6a60ec8';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;

  bool _cargando = false;

  List<Movie> _peliculasPopulares = List();

  final _popularesStreamController = new StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  /*******************************
   * Get movies from json response
   ********************************/
  Future<List<Movie>> getMoviesResponse(Uri url) async{
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  /*******************************
   * Get movies from api
   ********************************/
  Future<List<Movie>> getEnCines() async {

    Map<String,String> params = {
      'api_key' : _apiKey,
      'language' : _language
    };

    final url = Uri.https(_url, '3/movie/now_playing', params);

    return await getMoviesResponse(url);
  }

  /********************
   * Get populars movies from api
   ********************/
  Future<List<Movie>> getPopulares() async {

    if(_cargando) return []; 

    _cargando = true;

    print('cargando...');

    _popularesPage++;

    Map<String,String> params = {
      'api_key' : _apiKey,
      'language': _language,
      'page'    : _popularesPage.toString()
    };

    final url = Uri.https(_url, '3/movie/popular', params);

    final resp = await getMoviesResponse(url);

    _peliculasPopulares.addAll(resp);
    popularesSink(_peliculasPopulares);

    _cargando = false;

    return _peliculasPopulares;
  }

  /********************
   * Get movie actors by idMovie from api
   ********************/
   Future<List<Actor>> getActors(String movieId) async {

     Map<String,String> params = {
      'api_key' : _apiKey,
      'language': _language
    };

    final url = Uri.https(_url, '3/movie/$movieId/credits',params);

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

   }

  /*******************************
   * Get movies from api
   ********************************/
  Future<List<Movie>> getMovieByQuery(String query) async {

    Map<String,String> params = {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query
    };

    final url = Uri.https(_url, '3/search/movie', params);

    return await getMoviesResponse(url);
  }

}