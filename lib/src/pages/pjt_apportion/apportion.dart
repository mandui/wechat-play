import 'dart:html';
import 'package:angular/angular.dart';

import 'package:route_play/src/comp/nav_bar/nav_bar.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:route_play/src/data/project.dart';
import 'package:route_play/src/data/local_store.dart' as store;

@Component(
    selector: 'pjt-apportion',
    templateUrl: 'apportion.html',
    directives: [NavBarComponent, NgFor, NgIf, FaIcon],
    styleUrls: ['apportion.css']
)

class ApportionComponent implements OnInit {

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.pjt_apportion);
    project = store.findCurrProject();

    final addr = store.currentProperty.propAddr;
    if (addr != null && addr.isNotEmpty) {
      List<String> parts = addr.split("区");
      if (parts.length > 1)
        querySelector("title").text = parts[1];
      else
        querySelector("title").text = "查看分摊清册";
    } else
      querySelector("title").text = "查看分摊清册";

    project.apportionDetails;
  }

  Project project;


}