import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';

@Component (
  selector: 'my-details',
  templateUrl: 'details_v2.html',
  styleUrls: ['details_v2.css'],
  directives: [ NgFor, NgIf, routerDirectives, FaIcon, NavBarComponent],
)


class DetailsComponent implements OnInit {

  DetailsComponent();
  Property prop;
  List<InfoItem> infoItems;
  String fundStr;
  String frozenFundStr;

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.prop_details);
    querySelector("title").text = "维修资金详情";
    prop = store.currentProperty?? store.properties[0];
    _prepareInfo();

    num fund = prop.account.money + prop.account.interest;
    fundStr = fund.toStringAsFixed(2) + " 元";

    num frozenFund = prop.account.freezedMoney = prop.account.freezedInterest;
    frozenFundStr = frozenFund.toStringAsFixed(2) + " 元";
  }

  void _prepareInfo() {
    infoItems = List();
    List<InfoItem> temp = List();
    temp.add(InfoItem("业主", prop.ownerInfo.name));
    temp.add(InfoItem("证件号码", prop.ownerInfo.id));
    temp.add(InfoItem("联系电话", prop.ownerInfo.tel));
    temp.add(InfoItem("电子邮箱", prop.ownerInfo.email));
    temp.add(InfoItem("房屋面积", "${prop.propInfo.area} ㎡"));
    temp.add(InfoItem("购买时间", prop.propInfo.boughtDate));
    if (prop.propInfo.price > 0)
      temp.add(InfoItem("售价", "${prop.propInfo.price}元"));
    temp.add(InfoItem("资金账号", prop.account.accountNo));

    for (InfoItem item in temp) {
      if (item.contents != null && item.contents.trim().isNotEmpty)
        infoItems.add(item);
    }
  }

  bool showLogs() {
    bool notShow = prop.account == null
        || prop.account.accountLog == null
        || prop.account.accountLog.isEmpty;
    return !notShow;
  }
}

class InfoItem {
  InfoItem(this.title, this.contents);
  String title;
  String contents;
}