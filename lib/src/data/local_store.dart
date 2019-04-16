library route_play.store;

import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/data/project.dart';

bool debug = true;

Property currentProperty;
List<Property> properties;
Map<String, List<Project>> groupProject;
/// currProject is projectNo
String currPjtNo;
Future<bool> fetchProjectDone;
String enterFrom = "";

/// fetch articles when
Future<bool> fetchArticleDone;


void reset() {
  currentProperty = null;
  groupProject = Map();
  currPjtNo = "";
  properties = null;
  enterFrom = "";
  currLoc = Loc.login;
  prevLoc = Loc.login;
}

enum Loc {
  login, entry, prop_list, prop_details,
  pjt_list, pjt_apportion, pjt_vote,
  article_list, article
}

Loc currLoc = Loc.login;
Loc prevLoc = Loc.login;

void setLoc(Loc curr) {
  prevLoc = currLoc;
  currLoc = curr;
}

Project findCurrProject() {
  String accountNo = currentProperty.account.accountNo;
  String pjtNo = currPjtNo;
  for ( Project pjt in groupProject[accountNo]) {
    if (pjt.projectNo == pjtNo) {
      return pjt;
    }
  }
  return null;
}