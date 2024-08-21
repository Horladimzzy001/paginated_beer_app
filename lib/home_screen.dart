import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'beer_provider.dart';
import 'details.dart';



class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.fetchPosts(1); // Fetch the first page of data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Posts', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading && postProvider.posts.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (postProvider.posts.isEmpty) {
            return Center(child: Text('No posts available'));
          }

          return ListView.builder(
            itemCount: postProvider.posts.length + (postProvider.hasMorePosts ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == postProvider.posts.length) {
                postProvider.loadMorePosts(); // Fetch more data
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Loading more posts...'),
                      SizedBox(width: 5),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final post = postProvider.posts[index];
              return GestureDetector(
                onTap: () {
                  //passing of each post news to a new screen using Provider State Management
                  postProvider.title = post.title;
                  postProvider.body = post.body;
                  // Navigate to the details screen and pass the post data
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
    );
  }
}
