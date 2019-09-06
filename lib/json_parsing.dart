import 'dart:convert' as json;
import 'package:built_value/built_value.dart';
import 'package:flutter_hacker_news/src/artical.dart';

part 'json_parsing.g.dart';

    abstract class Article implements Built<Article, ArticleBuilder> {

      int get id;

      Article._();
      factory Article([void Function(ArticleBuilder) updates]) = _$Article;
    }


List<int> parseTopStories(String jsonStr) {

  return [];
//  final parsed = json.jsonDecode(jsonStr);
//
//  final listOfIds = List<int>.from(parsed);
//  return listOfIds;
}

Article parseArticle(String jsonStr) {
//  final parsed = json.jsonDecode(jsonStr);
//
//  Article article = Article.fromJson(parsed);
//
//  return article;
}
