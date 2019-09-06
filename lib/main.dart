import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  List<Article> _articles = []; //articles;

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

  Future<Article> _getArticle(int id) async {
    final storyurl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyres = await http.get(storyurl);

    if (storyres.statusCode == 200) {
      return parseArticle(storyres.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _ids
            .map((i) => FutureBuilder<Article>(
                  future: _getArticle(i),
                  builder:
                      (BuildContext context, AsyncSnapshot<Article> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(snapshot.data.title);
                    } else {
                      return Text("Not done..!!");
                    }

                    return null;
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.text),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.text,
          style: TextStyle(fontSize: 24),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
//              Text("${article.commentsCount} comments"),
              IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
//                  final fakeurl = "http://${article.domain}";
//                  if (await canLaunch(fakeurl)) {
//                    launch(fakeurl);
//                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
