import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'beer_service.dart';
 // Ensure this file defines your Post class

class PostProvider extends ChangeNotifier {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> _posts = [];
  String title = '';
  String body = '';

  bool _isLoading = false;
  bool _hasMorePosts = true;
  int _currentPage = 1;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMorePosts => _hasMorePosts;

  Future<void> fetchPosts(int page) async {
    if (_isLoading || !_hasMorePosts) return;

    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('$_baseUrl?_page=$page&_limit=10'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Post> newPosts = jsonResponse.map((post) => Post.fromJson(post)).toList();

      if (newPosts.length < 10) {
        _hasMorePosts = false; // No more posts to fetch from the endpoint
      }

      _posts.addAll(newPosts);
      _currentPage = page;
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load posts from the endpoint');
    }
  }

  void loadMorePosts() {
    fetchPosts(_currentPage + 1);
  }
}
