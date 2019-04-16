import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/route_paths.dart';
import 'package:route_play/src/routes.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:route_play/src/data/local_store.dart' as store;

@Component (
  selector: 'nav-bar',
  templateUrl: 'nav_bar.html',
  styleUrls: ['nav_bar.css'],
  directives: [NgIf, routerDirectives, FaIcon, NgClass],
  exports: [RoutePaths, Routes],
)


class NavBarComponent implements OnInit {

  // todo need rewrite, it should be a stack, pop and push
  // todo logic is not clear

  @override
  void ngOnInit() {}

  bool showPropList() {
    bool showAllMode = _shouldShowPropList() && !_inBriefMode();
    bool showBriefMode = _shouldShowPropList() && _inBriefMode() && inPrev;

    return showAllMode || showBriefMode;
  }

  bool _shouldShowPropList() {
    bool locCheck = store.currLoc == store.Loc.prop_list
        || store.currLoc == store.Loc.prop_details
        || store.currLoc == store.Loc.pjt_list
        || store.currLoc == store.Loc.pjt_vote
        || store.currLoc == store.Loc.pjt_apportion;

    bool propNumCheck = store.properties != null
        && store.properties.length > 1;

    return locCheck && propNumCheck;
  }

  bool inPropList() {
    return store.currLoc == store.Loc.prop_list;
  }

  bool showEntry() {
    bool showAllMode = !_inBriefMode();
    bool showBriefMode =  _inBriefMode() && inPrev;
    return showAllMode || showBriefMode;
  }

  // always showed
  bool showDetails() {
    return store.currLoc == store.Loc.prop_details;
  }

  bool showPjtVote() {
    bool showAllMode = _shouldShowPjtVote() && !_inBriefMode();
    bool showBriefMode = _shouldShowPjtVote() && _inBriefMode() && !inPrev;
    return showAllMode || showBriefMode;
  }

  bool _shouldShowPjtVote() {
    return store.currLoc == store.Loc.pjt_vote;
  }

  bool showPjtApportion() {
    bool showAllMode = _shouldPjtShowApportion() && !_inBriefMode();
    bool showBriefMode = _shouldPjtShowApportion() && _inBriefMode() && !inPrev;
    return showAllMode || showBriefMode;
  }

  bool _shouldPjtShowApportion() {
    return store.currLoc == store.Loc.pjt_apportion;
  }

  bool showPjtList() {
    bool showAllMode = _shouldShowPjtList() && !_inBriefMode();
    bool showBriefMode = _shouldShowPjtList() && _inBriefMode() && !inPrev;
    return showAllMode || showBriefMode;
  }

  bool _shouldShowPjtList() {
    bool locCheck = store.currLoc == store.Loc.pjt_list
        || store.currLoc == store.Loc.pjt_apportion
        || store.currLoc == store.Loc.pjt_vote;

    return locCheck;
  }

  bool inPjtList() {
    return store.currLoc == store.Loc.pjt_list;
  }

  bool inPrev = false;
  bool _inBriefMode() {
    bool locCheck = store.currLoc == store.Loc.pjt_apportion
        || store.currLoc == store.Loc.pjt_vote;

    bool numCheck = _shouldShowPropList();
    return locCheck && numCheck;
  }

  bool showPrev() {
    return _inBriefMode() && !inPrev;
  }

  void displayPrev() {
    inPrev = true;
  }

  bool showNext() {
    return _inBriefMode() && inPrev;
  }

  void displayNext() {
    inPrev = false;
  }

  bool showPolicyList() {
    bool locCheck = store.currLoc == store.Loc.article_list
        && store.enterFrom == "policy";

    return locCheck;
  }

}