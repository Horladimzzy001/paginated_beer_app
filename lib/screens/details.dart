import 'package:flutter/material.dart';
import 'package:paginated_beer_app/stateManagement/beer_provider.dart';
import 'package:provider/provider.dart';


class PostDetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(title: Text('News Detailed Screen')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  value.body,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
