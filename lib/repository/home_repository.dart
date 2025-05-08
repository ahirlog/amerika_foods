import 'package:flutter_notes/data/network/base_api_service.dart';
import 'package:flutter_notes/data/network/network_api_service.dart';
import 'package:flutter_notes/model/movies_model.dart';
import 'package:flutter_notes/res/app_url.dart';

class HomeRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<MovieListModel> fetchMoviesList() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse(AppUrl.moviesListEndPoint);
      return MovieListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
