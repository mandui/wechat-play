class Project {

  Project(this.accountNo);

  String accountNo;
  String projectNo;
  String projectName;
  String projectDesc;
  String apportionType;
  String chosen = "";
  String opinion;
  bool votable;
  num area;
  num money;
  num totalArea;
  num totalOwner;
  num totalMoney;
  num budget;
  String deadline;
  List<ApportionItem> apportionDetails;

  void assignValues(Map<String, dynamic> json) {
    projectNo = json[KEY_PJT_NO] ?? "";
    projectName = json[KEY_PJT_NAME] ?? "";
    projectDesc = json[KEY_PJT_DESC] ?? "";
    apportionType = json[KEY_PJT_APT_TYPE] ?? "";
    area = json[KEY_PJT_AREA] ?? 0.0;
    money = json[KEY_PJT_MONEY] ?? 0.0;
    totalMoney = json[KEY_PJT_TOTAL_MONEY] ?? 0.0;
    totalArea = json[KEY_PJT_TOTAL_AREA] ?? 0.0;
    totalOwner = json[KEY_PJT_TOTAL_OWNER] ?? 0;
    budget = json[KEY_PJT_BUDGET] ?? 0;
    deadline = json[KEY_PJT_DEADLINE] ?? "";
    chosen = json[KEY_PJT_VOTE_CHOSEN] ?? "";
    opinion = json[KEY_PJT_VOTE_OPINION] ?? "";

    String incomeVote = json[KEY_PJT_VOTABLE];
    if (incomeVote == null) votable = false;
    else votable = (incomeVote.toLowerCase() == "true");

  }

  void assignDetails(List<Map<String, dynamic>> json) {
    apportionDetails = List();
  }

  String transVoteType(String voteType) {
    switch(voteType) {
      case "agree": return "同意";
      case "disagree": return "不同意";
      case "waiver": return "弃权";
      default: return "投票";
    }
  }

}

class ApportionItem {
  String houseLocation;
  num area;
  num money;

  ApportionItem.fromJson(Map<String, dynamic> json) {
    houseLocation = json[KEY_APT_LOCATION] ?? "";
    area = json[KEY_APT_AREA] ?? 0.0;
    money = json[KEY_APT_MONEY] ?? 0.0;
  }
}

const KEY_PJT = "PROJECT_LIST";
const KEY_PJT_NO = "PROJECT_NO";
const KEY_PJT_NAME = "PROJECT_NAME";
const KEY_PJT_DESC = "PROJECT_DESC";
const KEY_PJT_APT_TYPE = "APPORTION_TYPE";
const KEY_PJT_VOTABLE = "VOTABLE";
const KEY_PJT_VOTE_CHOSEN = "VOTE_TYPE";
const KEY_PJT_VOTE_OPINION = "VOTE_DESC";
// this owner apportion area
const KEY_PJT_AREA = "AREA";
// this owner apportion money
const KEY_PJT_MONEY = "MONEY";
const KEY_PJT_TOTAL_AREA = "TOTAL_AREA";
const KEY_PJT_TOTAL_MONEY = "TOTAL_MONEY";
const KEY_PJT_TOTAL_OWNER = "TOTAL_OWNER_NUM";
const KEY_PJT_BUDGET = "BUDGET";
const KEY_PJT_DEADLINE = "DEADLINE";

const KEY_APT = "APPORTION_LIST";
const KEY_APT_LOCATION = "HOUSE";
const KEY_APT_AREA = "AREA";
const KEY_APT_MONEY = "MONEY";



