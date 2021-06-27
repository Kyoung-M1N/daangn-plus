import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              child: Text("Test"),
              onPressed: () => getList(),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Builder(
                    builder: (context) {
                      List<Widget> result = [];

                      for (var item in dItems) {
                        result.add(
                          Container(
                            width: 300,
                            height: 300,
                            child: Column(
                              children: [
                                Image.network(item.photo),
                                Text(item.status),
                                Text(item.time),
                                Text(item.title),
                                Text(item.location),
                                Text(item.price),
                                Row(
                                  children: [
                                    Text("chats " + item.chats.toString()),
                                    Text(" | likes " + item.likes.toString()),
                                    Text(" | views " + item.views.toString()),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () => html.window.open(
                                      "https://www.daangn.com/articles/" +
                                          item.article.toString(),
                                      "_blank"),
                                  child: Text("보러가기"),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: result,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getList() async {
    http.Response result = await http.get(Uri.parse(
        "https://daangnplus.doky.space/api/search?name=%EC%8A%A4%EC%BB%AC%ED%8A%B8%EB%9D%BC"));

    List<dynamic> tmp = jsonDecode(result.body);
    for (var i in tmp) {
      dItems.add(
        new DaangnItem(
          article: i['article'],
          photo: i['photo'],
          title: i['title'],
          location: i['location'],
          price: i['price'],
          status: i['status'],
          chats: i['chats'],
          likes: i['likes'],
          views: i['views'],
          time: i['time'],
        ),
      );
    }

    setState(() {});
  }
}

List<DaangnItem> dItems = [];

class DaangnItem {
  DaangnItem({
    required this.article,
    required this.photo,
    required this.title,
    required this.location,
    required this.price,
    required this.status,
    required this.chats,
    required this.likes,
    required this.views,
    required this.time,
  });

  final int article;
  final String photo;
  final String title;
  final String location;
  final String price;
  final String status;
  final int chats;
  final int likes;
  final int views;
  final String time;
}
