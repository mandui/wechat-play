import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/data/project.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:route_play/src/route_paths.dart';
import 'package:route_play/src/routes.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';
import 'package:route_play/src/comp/tip_message/tip_msg.dart';

import 'package:route_play/src/data/data_service.dart';


@Component (
  selector: 'prop-list',
  templateUrl: 'prop_list_v2.html',
  styleUrls: ['prop_list_v2.css'],
  directives: [ NgFor, NgIf, routerDirectives, FaIcon, NavBarComponent, TipMessage],
  providers: [ClassProvider(DataService)],
  exports: [RoutePaths, Routes],
)


class PropsComponent implements OnInit {

  PropsComponent(this._router, this._service);

  List<Property> properties;
  Property selected;
  String footerMsg;
  String _nextUrl;
  Router _router;
  DataService _service;

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.prop_list);
    querySelector("title").text = "选择您想查询的房产";
    properties = store.properties;
    _preflight();
  }

  bool tipLoading = false;
  bool tipError = false;
  String errorMsg = "";
  void select(Property prop) async {
    store.currentProperty = prop;
    if (store.enterFrom == 'fund')
      await _router.navigate(_nextUrl);

    if (store.enterFrom == "project")
      await _goProjects(prop.account.accountNo);
  }

  void _goProjects(String accountNo) async {
    /// check if this info is fetched already
    if (store.groupProject.containsKey(accountNo))
      await _router.navigate(_nextUrl);
    else {
      tipLoading = true;
      Map<String, dynamic> retMap = await _service.fetchProjects(accountNo);
      if (retMap.containsKey(KEY_ERROR_MSG)) {
        tipLoading = false; tipError = true;
        errorMsg = retMap[KEY_ERROR_MSG];
      } else {
        List<Project> projects = retMap[KEY_PJT] as List<Project>;
        store.groupProject[accountNo] = projects;
        tipLoading = false;
        await _router.navigate(_nextUrl);
      }
    }
  }

  void _preflight() {
    switch(store.enterFrom) {
      case 'fund':
        footerMsg = "查询 维修资金详情";
        _nextUrl = Routes.details.toUrl();
        break;
      case 'project':
        footerMsg = "查询 小区维修事项";
        _nextUrl = Routes.projects.toUrl();
        break;
      default: footerMsg = "查询详情";
    }
  }

  List<InfoItem> briefInfo(Property prop) {
    List<InfoItem> infoItems = List();
    infoItems.add(InfoItem("账号", prop.account.accountNo));
    infoItems.add(InfoItem("地址", prop.propAddr));
    infoItems.add(InfoItem("面积", "${prop.propInfo.area} ㎡"));

    num fund = prop.account.money + prop.account.interest;
    String fundStr = fund.toStringAsFixed(2) + " 元";
    infoItems.add(InfoItem("维修金", fundStr));

    num frozenFund = prop.account.freezedMoney + prop.account.freezedInterest;
    String frozenFundStr = frozenFund.toStringAsFixed(2) + " 元";
    infoItems.add(InfoItem("冻结额", frozenFundStr));

    return infoItems;
  }

}

class InfoItem {
  InfoItem(this.title, this.contents);
  String title;
  String contents;
}