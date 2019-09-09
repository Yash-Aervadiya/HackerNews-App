import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/article.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:rxdart/rxdart.dart';

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsBloc {


  Stream<bool> get isLoading => _isloadingSubject.stream;

  final _isloadingSubject = BehaviorSubject<bool>();

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiestypeController.sink;

  final _storiestypeController = StreamController<StoriesType>();

  static List<int> _newIds = [
    20875098,
    20887708,
    20880576,
    20861948,
    20876960
  ]; //articles;

  static List<int> _topIds = [
    20876248,
    20854214,
    20890682,
    20874006,
    20888817,
    20880789,
  ];

  HackerNewsBloc() {
    _getArticleAndUpdate(_topIds);
    _storiestypeController.stream.listen((storiesType) {
      if (storiesType == StoriesType.newStories) {
        _getArticleAndUpdate(_newIds);
      } else {
        _getArticleAndUpdate(_topIds);
      }
    });
  }

  _getArticleAndUpdate(List<int> ids) async {

    _isloadingSubject.add(true);
    await _updateArticles(ids);
      _articlesSubject.add(UnmodifiableListView(_articles));
      _isloadingSubject.add(false);

  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));

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
