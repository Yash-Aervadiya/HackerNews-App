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

  void close() {
    _storiestypeController.close();
  }

  HackerNewsBloc() {
    _intializeArticles();

    _storiestypeController.stream.listen((storiesType) async {
      _getArticleAndUpdate(await _getIds(storiesType));
    });
  }


  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

    Future<List<int>> _getIds(StoriesType type) async {

    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    final url = '$_baseUrl${partUrl}stories.json';
    print("url == $url");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw HackerNewsApiError("Stories $type couldn't be fetched");
    }
    return parseTopStories(response.body).take(10).toList();
  }

  Future<void> _intializeArticles() async {
    _getArticleAndUpdate(await _getIds(StoriesType.topStories));
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
    print("_articles + ${articles.length}");
  }

  Future<Article> _getArticle(int id) async {
    final storyurl = '${_baseUrl}item/$id.json';
    final storyres = await http.get(storyurl);

    if (storyres.statusCode == 200) {
      return parseArticle(storyres.body);
    }
    throw HackerNewsApiError("Article $id couldn't be fetched");
  }
}

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}
