import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../logic/beer_service.dart';


class PostProvider extends ChangeNotifier {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  List<Post> _posts = [];
  String title = '';
  String body = '';

  bool _isLoading = false;
  bool _hasMorePosts = true;
  int _currentPage = 1;

  bool _hasShownError = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMorePosts => _hasMorePosts;

  Future<void> fetchPosts({required int page, required BuildContext context}) async {
    if (_isLoading || !_hasMorePosts) return;

    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final response = await http.get(Uri.parse('$_baseUrl?_page=$page&_limit=10'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Post> newPosts = jsonResponse.map((post) => Post.fromJson(post)).toList();

        if (newPosts.length < 10) {
          _hasMorePosts = false; // No more posts to fetch from the endpoint
        }

        _posts.addAll(newPosts);
        _currentPage = page;

        _hasShownError = false;

      } else {
        throw Exception('Failed to load posts from the endpoint');
      }
    } on SocketException {
      _handleError('No internet connection. Please check your connection.', context);
    } on HttpException {
      _handleError('Failed to load data. Please try again later.', context);
    } on FormatException {
      _handleError('Bad response format.', context);
    } catch (e) {
      _handleError('An unexpected error occurred.', context);
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  void loadMorePosts(BuildContext context) {
    fetchPosts(page: _currentPage + 1, context: context);
  }


  void _handleError(String message, BuildContext context) {
    if (!_hasShownError) {
      _showSnackBar(message, context);
      _hasShownError = true;
    }
  }

  _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
