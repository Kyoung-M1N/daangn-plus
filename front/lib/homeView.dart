import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: CupertinoButton(
                          color: Colors.grey.shade200,
                          child: Text(
                            "Load",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onPressed: () => getList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: !isLoading
                        ? ListView(
                            children: [
                              Builder(
                                builder: (context) {
                                  List<Widget> result = [];

                                  result.add(SizedBox(height: 30));

                                  for (var item in dItems) {
                                    result.add(
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Image.network(
                                                    item.photo,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  // child: Image(
                                                  //   fit: BoxFit.fitWidth,
                                                  //   image: AssetImage(
                                                  //     "sample.png",
                                                  //   ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Card(
                                                              elevation: 2,
                                                              color: item.status ==
                                                                      "instock"
                                                                  ? Colors.green
                                                                  : Colors.grey
                                                                      .shade400,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  25,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.circle,
                                                                size: 20,
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                        0),
                                                              ),
                                                            ),
                                                            Text(
                                                              " " +
                                                                  item.status +
                                                                  "  ",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                            Text(
                                                              item.time,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          item.title,
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              item.price,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: item.status ==
                                                                        "instock"
                                                                    ? Colors
                                                                        .orange
                                                                    : Colors
                                                                        .grey
                                                                        .shade400,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(item.location),
                                                          ],
                                                        ),
                                                        SizedBox(height: 15),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .conversation_bubble,
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(item.chats
                                                                .toString()),
                                                            SizedBox(width: 15),
                                                            Icon(
                                                              CupertinoIcons
                                                                  .hand_thumbsup,
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(item.likes
                                                                .toString()),
                                                            SizedBox(width: 15),
                                                            Icon(
                                                              CupertinoIcons
                                                                  .eye,
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 7),
                                                            Text(item.views
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 120,
                                                    width: 70,
                                                    child: CupertinoButton(
                                                      color: item.status ==
                                                              "instock"
                                                          ? Colors.orange
                                                          : Colors
                                                              .grey.shade300,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      onPressed: () =>
                                                          html.window.open(
                                                              "https://www.daangn.com/articles/" +
                                                                  item.article
                                                                      .toString(),
                                                              "_blank"),
                                                      child: Text("보러\n가기"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Divider(),
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
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "로딩중..",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getList() async {
    if (!isLoading) {
      setState(() {});
      isLoading = true;

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
      isLoading = false;
    }
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
