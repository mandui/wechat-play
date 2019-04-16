import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:route_play/src/data/data_service.dart';
import 'package:route_play/src/data/project.dart';
import 'package:route_play/src/route_paths.dart';
import 'package:route_play/src/routes.dart';
import 'package:route_play/src/comp/tip_message/tip_msg.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';

@Component (
  selector: 'entry',
  templateUrl: 'entry.html',
  styleUrls: ['style.css', 'entry.css'],
  directives: [NgIf,routerDirectives, TipMessage, FaIcon, NgFor],
  providers: [ClassProvider(DataService)],
  exports: [RoutePaths, Routes],
)


class EntryComponent implements OnInit{

  final entries = [
    Entry("policy", "政策法规", "images/icon-sc-001.png"),
    Entry("announcement", "公示公告", "images/icon-sc-002.png"),
    Entry("project", "维修投票", "images/icon-sc-003.png"),
    Entry("fund", "资金查询", "images/icon-sc-004.png"),
    Entry("instruction", "办理指南", "images/icon-sc-005.png"),
    Entry("more", "更多服务", "images/icon-sc-006.png"),
  ];

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.entry);
    querySelector("title").text = "维修资金查询系统";
    //store.fetchProjectDone = _service.fetchProjects();

    //String url = Uri.base.toString();
    //print(url);
  }

  EntryComponent(this._router, this._service);
  Router _router;
  DataService _service;

  void enter(String entryPoint) {
    store.currentProperty = null;
    store.enterFrom = entryPoint;
    switch(entryPoint) {
      case 'policy':
      case 'notification':
      case 'instruction':
      case 'more':
        errorMsg = "此功能尚在建设中，敬请期待";
        tipError = true;
        break;
      case 'fund':
        _goQuery(); break;
      case 'project':
        _goProjects(); break;
    }
  }

  void _goArticleList(String articleType) {

  }

  void _goQuery() {
    if (store.properties.length == 1) {
      store.currentProperty = store.properties[0];
      _router.navigate(Routes.details.toUrl());
    } else
      _router.navigate(Routes.props.toUrl());
  }

  bool goProjects = false;
  bool tipLoading = false;
  bool tipError = false;
  String errorMsg = "";
  void _goProjects() async {
    goProjects = true;

    if (store.properties.length == 1) {
      store.currentProperty = store.properties[0];
      String accountNo = store.currentProperty.account.accountNo;
      tipLoading = true;
      Map<String, dynamic> retMap = await _service.fetchProjects(accountNo);
      if (retMap.containsKey(KEY_ERROR_MSG)) {
        tipLoading = false; tipError = true;
        errorMsg = retMap[KEY_ERROR_MSG];
      } else {
        List<Project> projects = retMap[KEY_PJT] as List<Project>;
        store.groupProject[accountNo] = projects;
        tipLoading = false;
        await _router.navigate(Routes.projects.toUrl());
      }
    } else
      await _router.navigate(Routes.props.toUrl());
  }


}

class Entry {
  String type;
  String iconUrl;
  String title;
  Entry(this.type, this.title, this.iconUrl);
}