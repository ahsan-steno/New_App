import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newa_api/Models/categori_news_model.dart';

import 'package:newa_api/Models/new_channels_headlines_model.dart';
class NewsRepositry{




  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineAPI(String channelName)async{
    String url ='https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=0e9a15a97311418bab53ebf17296527a';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final body =jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);

    }throw Exception('Error');
  }
  Future<CategoriesNewsModel> fetchCategoriesNews(String category)async{
    String url = 'https://newsapi.org/v2/everything?Q=${category}&apiKey=0e9a15a97311418bab53ebf17296527a';
    print(url);

    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }

    if(response.statusCode == 200){
      final body =jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);

    }throw Exception('Error');
  }

}