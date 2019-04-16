import 'package:angular/angular.dart';
import 'package:route_play/src/data/article.dart';

@Component(
  selector: 'articles',
  templateUrl: 'article_list.html',
  styleUrls: ['article_list.css'],
  directives: [NgFor, NgIf]
)
class ArticleList implements OnInit {

  List<Article> articles;

  void setData(List<Article> articles) {
    this.articles = articles;
  }

  String innerLines = "<h1>Fake Article Title</h1>";

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }

}