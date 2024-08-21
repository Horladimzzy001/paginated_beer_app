import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stateManagement/beer_provider.dart';
import 'details.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Offset _fabPosition;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.fetchPosts(page: 1, context: context); // Fetch the first page of data
    });

    _fabPosition = const Offset(30, 500);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fabSize = 56.0; // Default size of FloatingActionButton
    final EdgeInsets padding = MediaQuery.of(context).padding; // Get screen padding to account for the bottom nav bar

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Posts', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              if (postProvider.isLoading && postProvider.posts.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              if (postProvider.posts.isEmpty) {
                return Center(child: Text('No posts available'));
              }

              return ListView.builder(
                itemCount: postProvider.posts.length + (postProvider.hasMorePosts ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == postProvider.posts.length) {
                    postProvider.loadMorePosts(context); // Fetch more data
                    return const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.lightGreenAccent,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final post = postProvider.posts[index];
                  return GestureDetector(
                    onTap: () {
                      postProvider.title = post.title;
                      postProvider.body = post.body;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(),
                        ),
                      );
                    },
                    child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          title: Text('Post Title: ' + post.title),
                          subtitle: Text('Post Body: ' + post.body),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX = _fabPosition.dx + details.delta.dx;
                  double newY = _fabPosition.dy + details.delta.dy;

                  newX = newX.clamp(20.0, screenSize.width - fabSize - 20.0);
                  newY = newY.clamp(20.0 + padding.top, screenSize.height - fabSize - 20.0 - padding.bottom);

                  _fabPosition = Offset(newX, newY);
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  final postProvider = Provider.of<PostProvider>(context, listen: false);
                  postProvider.fetchPosts(page: 1, context: context); // Refresh posts
                },
                child: Icon(Icons.refresh),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
