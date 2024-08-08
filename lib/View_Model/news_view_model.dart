


import 'package:newa_api/Models/categori_news_model.dart';
import 'package:newa_api/repositry/new_repositry.dart';

import '../Models/new_channels_headlines_model.dart';



class NewsViewModel{
  final _rep = NewsRepositry();


  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineAPI(String channelName) async{

    final response =await _rep.fetchNewsChannelHeadlineAPI(channelName);
    return response;

  }
  Future<CategoriesNewsModel> fetchCategoriesNews(String category) async{

    final response =await _rep.fetchCategoriesNews(category);
    return response;

  }

}