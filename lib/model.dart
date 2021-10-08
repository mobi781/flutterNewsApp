class NewsQueryModel {
  late String headLine;
  late String description;
  late String newsImage;
  late String newsUrl;
  NewsQueryModel(
      {this.headLine = "NEWS HEADLINE",
      this.description = "NEWS",
      this.newsImage = "Image",
      this.newsUrl = "URL"});

  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
        headLine: news["title"],
        description: news["description"],
        newsImage: news["urlToImage"],
        newsUrl: news["url"]);
  }
}
