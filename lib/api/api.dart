import 'dart:convert';

import 'package:flutflix/models/movie.dart';
import 'package:flutflix/constants.dart';
import 'package:http/http.dart' as http;

class Api {
    static const _trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
    static const _topRateUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
    static const _upcomingUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';

    Future<List<Movie>> getTrendingMovies() async{
      final respone = await http.get(Uri.parse(_trendingUrl));
      if(respone.statusCode == 200) {
        final decodeData = json.decode(respone.body)['results'] as List;
        print(decodeData);
        return decodeData.map((movie) => Movie.fromJson(movie)).toList();
      }else{
        throw Exception('Something happend');
      }
    }

     Future<List<Movie>> getTopRateMovies() async{
      final respone = await http.get(Uri.parse(_topRateUrl));
      if(respone.statusCode == 200) {
        final decodeData = json.decode(respone.body)['results'] as List;
        print(decodeData);
        return decodeData.map((movie) => Movie.fromJson(movie)).toList();
      }else{
        throw Exception('Something happend');
      }
    }

    
     Future<List<Movie>> getUpcomingMovies() async{
      final respone = await http.get(Uri.parse(_upcomingUrl));
      if(respone.statusCode == 200) {
        final decodeData = json.decode(respone.body)['results'] as List;
        print(decodeData);
        return decodeData.map((movie) => Movie.fromJson(movie)).toList();
      }else{
        throw Exception('Something happend');
      }
    }
}