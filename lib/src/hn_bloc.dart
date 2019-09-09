import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/article.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:rxdart/rxdart.dart';

class HackerNewsBloc {

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];



  List<int> _ids = [
    20876248,
    20854214,
    20890682,
    20874006,
    20888817,
    20880789,
    20875098,
    20887708,
    20880576,
    20861948,
    20876960
  ]; //articles;

  HackerNewsBloc() {
    _updateArticles().then((_){

      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;


  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((id) => _getArticle(id));

    final articles = await Future.wait(futureArticles);

    _articles = articles;
  }

  Future<Article> _getArticle(int id) async {
    final storyurl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyres = await http.get(storyurl);

    if (storyres.statusCode == 200) {
      return parseArticle(storyres.body);
    }
  }
}
