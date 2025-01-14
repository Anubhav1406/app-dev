import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_detail_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'saved_articles_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> homeArticles = [];
  bool isLoading = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchHomeArticles();
  }

  Future<void> fetchHomeArticles() async {
    const String apiKey = 'dcd342c467204320aba37a90abbf4aec';
    final String apiUrl =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    try {
      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['articles'] != null && data['articles'].isNotEmpty) {
          setState(() {
            homeArticles = data['articles'];
            isLoading = false;
          });
        } else {
          setState(() {
            homeArticles = [];
            errorMessage = "No articles found.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch articles. Try again later.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please check your connection.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    child: Text("Tech"),
                    onPressed: () {},
                ),
                ElevatedButton(
                  child: Text("Sports"),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Text("Cinema"),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Article List Section
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: homeArticles.length,
              itemBuilder: (context, index) {
                final article = homeArticles[index];
                return ListTile(
                  title: Text(article["title"] ?? "No Title"),
                  subtitle: Text(
                      article["source"]["name"] ?? "Unknown Source"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(
                          title: article["title"],
                          description: article["description"] ?? "",
                          content: article["content"] ?? "",
                          url: article["url"] ?? "",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SearchScreen()));
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SavedArticlesScreen()));
          }
        },
      ),
    );
  }
}
