
import 'package:flutter/material.dart';

import 'data/data_display.dart';
import 'data/data_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArticleListScreen(),
    );
  }
}

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late Future<Welcome?> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = ApiService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: FutureBuilder<Welcome?>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.articles.isEmpty) {
            return Center(child: Text('No articles available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.articles.length,
              itemBuilder: (context, index) {
                final article = snapshot.data!.articles[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      article.urlToImage,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(article.title),
                    subtitle: Text(article.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailScreen(article: article),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.urlToImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              article.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Published on ${article.publishedAt}',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16.0),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}