import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';

@Component (
  selector: 'my-details',
  templateUrl: 'details.html',
  styleUrls: ['details.css'],
  directives: [ NgFor, NgIf, routerDirectives, FaIcon, NavBarComponent],
)


class DetailsComponent implements OnInit {

  DetailsComponent();
  Property prop;

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.prop_details);
    querySelector("title").text = "维修资金详情";
    prop = store.currentProperty?? store.properties[0];
  }

  bool showDate() {
    bool notShow = prop.propInfo.boughtDate == null
        || prop.propInfo.boughtDate.isEmpty;
    return !notShow;
  }

  bool showOwnerId() {
    bool notShow = prop.ownerInfo.id == null
        || prop.ownerInfo.id.isEmpty;
    return !notShow;
  }

  bool showPrice() {
    bool notShow = prop.propInfo.price == null
        || prop.propInfo.price <= 0;
    return !notShow;
  }

  bool showTel() {
    bool notShow = prop.ownerInfo.tel == null
        || prop.ownerInfo.tel.isEmpty;
    return !notShow;
  }

  bool showEmail() {
    bool notShow = prop.ownerInfo.email == null
        || prop.ownerInfo.email.isEmpty;
    num a = 2.321;
    a.toStringAsFixed(2);
    return !notShow;
  }

  bool showLogs() {
    bool notShow = prop.account == null
        || prop.account.accountLog == null
        || prop.account.accountLog.isEmpty;
    return !notShow;
  }

}