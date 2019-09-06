import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/artical.dart';

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
  List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
//          Scaffold.of(context)
//              .showSnackBar(SnackBar(content: Text("REFRESHED")));
          await new Future.delayed(const Duration(seconds: 1));

          setState(() {
            _articles.removeAt(0);
          });

          return;
        },
        child: ListView(
          children: _articles.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key : Key(article.text),

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
              Text("${article.commentsCount} comments"),
              IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
                  final fakeurl = "http://${article.domain}";
                  if (await canLaunch(fakeurl)) {
                    launch(fakeurl);
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
