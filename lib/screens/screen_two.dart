// without model

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  List<Photos> photosList = [];

  Future<List<Photos>> getPhotosApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      for (Map i in data) {
        Photos photos = Photos(
            albumId: i['albumId'],
            id: i['id'],
            title: i['title'],
            url: i['url'],
            thumbnailUrl: i['thumbnailUrl']);
        photosList.add(photos);
      }
      return photosList;
    } else {
      throw Exception('Failed to load the Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos Get API'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPhotosApi(),
              builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: photosList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data![index].url.toString()),
                        ),
                        title: Text(photosList[index].title),
                        trailing: Text(snapshot.data![index].title.toString()),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  throw Exception('${snapshot.hasData}');
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

class Photos {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  Photos({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });
}
