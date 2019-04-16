import 'package:angular/angular.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:route_play/src/data/project.dart';
import 'package:route_play/src/data/data_service.dart';
import 'package:route_play/src/comp/nav_bar/nav_bar.dart';
import 'package:route_play/src/comp/tip_message/tip_msg.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';

@Component (
  selector: 'pjt-vote',
  templateUrl: 'pjt_vote.html',
  styleUrls: ['pjt_vote.css'],
  directives: [NavBarComponent, NgFor, NgIf, FaIcon, formDirectives, TipMessage],
  providers: [ClassProvider(DataService)]
)

class VoteComponent implements OnInit {

  VoteComponent(this._service);
  DataService _service;

  @override
  void ngOnInit() {
    store.setLoc(store.Loc.pjt_vote);
    // TODO: implement ngOnInit
    project = store.findCurrProject();
    if(project.opinion.isNotEmpty)
      inputOpinion = project.opinion;

    if (project.chosen.isNotEmpty) {
      String vote = project.transVoteType(project.chosen);
      chosenMsg = "您选择了「${vote}」";
    }
  }

  Project project;

  String descMsg = "";
  String chosenMsg = "";

  bool tipLoading = false;
  bool tipError = false;
  String errorMsg = "";
  String inputOpinion;

  var lastOpinion = -1;
  var lastVote = -1;

  void submitOpinion() async {
    if (inputOpinion == null || inputOpinion.isEmpty) {
      descMsg = "您的意见不能为空。";
      errorMsg = "您的意见不能为空。";
      tipError = true;
    } else {
      if (_timeEnough(false)) {
        lastOpinion = DateTime.now().millisecondsSinceEpoch;
        tipLoading = true;
        Map<String, dynamic> retMap = await _service.sendOpinion(inputOpinion);
        String message = (retMap[KEY_ERROR_MSG] as String).trim();
        if (message.isEmpty) {
          tipLoading = false;
          descMsg = "意见提交成功！";
          project.opinion = inputOpinion;
        } else {
          errorMsg = message;
          descMsg = message;
          tipLoading = false;
          tipError = true;
        }
      } else _showTooOften();
    }
  }

  bool _timeEnough(bool isVote) {
    if (isVote)
      return lastVote < 0
        || DateTime.now().millisecondsSinceEpoch - lastVote > 15000;
    else
      return lastOpinion < 0
          || DateTime.now().millisecondsSinceEpoch - lastOpinion > 15000;
  }

  void vote(String voteType) async {
    if (_timeEnough(true)) {
      lastVote = DateTime.now().millisecondsSinceEpoch;
      tipLoading = true;
      Map<String, dynamic> retMap = await _service.sendVote(voteType);
      String message = (retMap[KEY_ERROR_MSG] as String).trim();
      if (message.isEmpty) {
        errorMsg = "投票成功！";
        String chosen = translate(voteType);
        chosenMsg = "您选择了「${chosen}」";
        project.chosen = voteType;
        tipLoading = false;
      } else {
        errorMsg = message;
        tipLoading = false;
        tipError = true;
      }
    } else _showTooOften();
  }

  void _showTooOften() {
    errorMsg = "您的操作太过频繁，请稍后再试";
    tipError = true;
  }

  String translate(String voteType) {
    switch (voteType) {
      case "agree": return "同意";
      case "disagree": return "不同意";
      default:
        return "弃权";
    }
  }

}