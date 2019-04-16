import 'dart:html';
import 'package:angular/angular.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';
import 'package:route_play/src/data/local_store.dart' as store;

@Component (
  selector: "vote",
  templateUrl: 'vote.html',
  styleUrls: ['vote.css'],
  directives: [routerDirectives, FaIcon, NavBarComponent]
)

class VoteComponent implements OnInit {

  @override
  void ngOnInit() {
    final addr = store.currentProperty.propAddr;
    if (addr != null && addr.isNotEmpty) {
      List<String> parts = addr.split("区");
      if (parts.length > 1)
        querySelector("title").text = parts[1];
      else
        querySelector("title").text = "小区维修事项决议";
    } else
        querySelector("title").text = "小区维修事项决议";

  }
}