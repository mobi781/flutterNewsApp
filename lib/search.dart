import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/webview.dart';

import 'model.dart';

class SearchResult extends StatefulWidget {
  // const SearchResult({Key? key}) : super(key: key);
  late final query;
  SearchResult({required this.query});
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool isLoading = true;
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];

  // getNewsByQuery(String query) async {
  //   String url =
  //       "https://newsapi.org/v2/everything?q=$query&from=2021-10-10&to=2021-10-10&sortBy=popularity&apiKey=8b8afcebecb04f7eb80ba5657d79a5ea";

  //   Response response = await get(Uri.parse(url));
  //   Map data = jsonDecode(response.body);
  //   setState(() {
  //     data["articles"].forEach((element) {
  //       NewsQueryModel newsQueryModel = new NewsQueryModel();
  //       newsQueryModel = NewsQueryModel.fromMap(element);
  //       newsModelList.add(newsQueryModel);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   });
  // }

  /// more effecient method for improve our app speed
  getNewsByQuery(String query) async {
    int indexes = 0;
    Map? element;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2021-10-10&to=2021-10-10&sortBy=popularity&apiKey=8b8afcebecb04f7eb80ba5657d79a5ea";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        indexes++;
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element as Map);
        newsModelList.add(newsQueryModel);
        if (indexes == 5) {
          setState(() {
            isLoading = false;
          });

          break;
        }
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Search")),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.query.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      child: CircularProgressIndicator(color: Colors.brown),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WebNews(newsModelList[index].newsUrl)));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      newsModelList[index].newsImage,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.brown.shade100
                                                .withOpacity(0),
                                            Colors.brown
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(8, 8, 10, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsModelList[index].headLine,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            newsModelList[index]
                                                        .description
                                                        .length >
                                                    50
                                                ? "${newsModelList[index].description.substring(0, 40)}..."
                                                : newsModelList[index]
                                                    .description,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
