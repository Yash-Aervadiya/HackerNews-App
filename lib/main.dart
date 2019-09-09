import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/hn_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(bloc: hnBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;


  MyApp({
    Key key,
    this.bloc,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', bloc: bloc,),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final HackerNewsBloc bloc;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  List<Article> _articles = []; //articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(

        stream: widget.bloc.articles,
          initialData: UnmodifiableListView<Article>([]),
          builder:(context ,snapshots) => ListView(
            children: snapshots.data.map(_buildItem).toList(),
          )
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
//      key: Key(article.title),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.title,
          style: TextStyle(fontSize: 24),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(article.type),
              IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
                  if (await canLaunch(article.url)) {
                    launch(article.url);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
