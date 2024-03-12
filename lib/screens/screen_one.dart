import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rest_api/models/post_model.dart';
import 'package:http/http.dart' as http;

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Post> postLists = [];

  Future<List<Post>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (Map<String, dynamic> i in data) {
        postLists.add(Post.fromJson(i));
      }
      return postLists;
    } else {
      throw Exception('Failed to load the data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get API'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: postLists.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(postLists[index].id.toString()),
                        title: Text(postLists[index].title.toString()),
                        subtitle: Text(postLists[index].body.toString()),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  throw Exception('${snapshot.hasError}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
