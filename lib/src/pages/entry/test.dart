void main() {
  // final uri = Uri.http("auth", "someplace", {"article": "some article"});

 // final str = "http://localhost:8080/#/article_list?article_type=policy";
  final str = "http://auth/someplace?article=some+article";
  final uri = Uri.parse(str);

  print(uri);
  print(uri.path);
  print(uri.query);
}