import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_detail_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'saved_articles_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  bool isLoading = false;
  String errorMessage = "";

  final searchController = TextEditingController();

  Future<void> fetchSearchResults(String query) async {
    const String apiKey = 'dcd342c467204320aba37a90abbf4aec';
    final String apiUrl =
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';

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
            searchResults = data['articles'];
            isLoading = false;
          });
        } else {
          setState(() {
            searchResults = [];
            errorMessage = "No results found for your query.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch results. Try again later.";
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
        title: Text("Search Articles"),
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
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = searchController.text.trim();
                    if (query.isNotEmpty) fetchSearchResults(query);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final article = searchResults[index];
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