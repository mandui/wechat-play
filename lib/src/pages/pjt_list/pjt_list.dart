import 'dart:html';
import 'package:angular/angular.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:route_play/src/data/project.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/routes.dart';
import 'package:route_play/src/data/data_service.dart';
import 'package:route_play/src/comp/tip_message/tip_msg.dart';

@Component (
  selector: 'pjt-list',
  templateUrl: 'pjt_list.html',
  styleUrls: ['pjt_list.css'],
    providers: [ClassProvider(DataService)],
    directives: [ NgFor, NgIf, routerDirectives, FaIcon, NavBarComponent, TipMessage ]
)

class ProjectListComponent implements OnInit {

  ProjectListComponent(this._router, this._service);
    Router _router;
    DataService _service;

    @override
    void ngOnInit() {
      store.setLoc(store.Loc.pjt_list);
      querySelector("title").text = "选择想要查看的维修项目";

      String accountNo = store.currentProperty.account.accountNo;
      projects = store.groupProject[accountNo];
    }

    List<Project> projects;
    bool tipLoading = false;
    bool tipError = false;
    String errorMsg = "";

    void goApportion(Project project) async {
      store.currPjtNo = project.projectNo;

      bool isNull = project.apportionDetails == null
          || project.apportionDetails.isEmpty;

      if (isNull) {
        String projectNo = store.currPjtNo;
        tipLoading = true;
        Map<String, dynamic> retMap = await _service.fetchApportionLog(projectNo);
        if (retMap.containsKey(KEY_ERROR_MSG)) {
          tipLoading = false; tipError = true;
          errorMsg = retMap[KEY_ERROR_MSG];
        } else {
          List<ApportionItem> aptList = retMap[KEY_APT] as List<ApportionItem>;
          String accountNo = store.currentProperty.account.accountNo;
          for (Project pjt in store.groupProject[accountNo]) {
            if (pjt.projectNo == projectNo) {
              pjt.apportionDetails = aptList;
              break;
            }
          }
          tipLoading = false;
          await _router.navigate(Routes.apportion.toUrl());
        }
      } else
        await _router.navigate(Routes.apportion.toUrl());
    }

    void goVote(Project project) {
      store.currPjtNo = project.projectNo;
      _router.navigate(Routes.vote.toUrl());
    }

    String voteButton(Project project) {
      if (project.votable) {
        String voted = project.transVoteType(project.chosen);
        if (voted == "投票") return voted;
        else return "已选择「$voted」";
      } else
        return "投票已结束";
  }

}