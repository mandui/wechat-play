const ERROR_VALUE = 0;

const KEY_PROP_LIST = "PROP_LIST";

const KEY_OWNER = "PROP_OWNER";
const KEY_OWNER_NAME = "NAME";
const KEY_OWNER_TEL = "TEL";
const KEY_OWNER_EMAIL = "EMAIL";
const KEY_OWNER_ID = "ID";

const KEY_PROP_ID = "PROP_ID";
const KEY_PROP_ADDR = "PROP_ADDR";

const KEY_PROP_INFO = "PROP_INFO";
const KEY_PROP_INFO_AREA = "AREA";
const KEY_PROP_INFO_DATE = "BOUGHT_DATE";
const KEY_PROP_INFO_PRICE = "PRICE";

const KEY_ACCOUNT = "PROP_ACCOUNT";
const KEY_ACCOUNT_F_MONEY = "FREEZED_MONEY";
const KEY_ACCOUNT_F_INTEREST = "FREEZED_INTEREST";
const KEY_ACCOUNT_MONEY = "MONEY";
const KEY_ACCOUNT_INTEREST = "INTEREST";
const KEY_ACCOUNT_NO = "ACCOUNT_NO";
const KEY_ACCOUNT_BANK = "BANK_NAME";
const KEY_ACCOUNT_LOG = "ACCOUNT_LOG";
const KEY_ACCOUNT_LOG_MONEY = "MONEY";
const KEY_ACCOUNT_LOG_PURPOSE = "PURPOSE";
const KEY_ACCOUNT_LOG_TIME = "TIME";

class Property {

  String index;

  String propId;
  String propAddr;
  _OwnerInfo ownerInfo;
  _Account account;
  _PropInfo propInfo;

  Property.fromJson(Map<String, dynamic> json) {
    propId = json[KEY_PROP_ID] ?? "";
    propAddr = json[KEY_PROP_ADDR] ?? "";

    if (json[KEY_OWNER] != null)
      ownerInfo = _OwnerInfo.fromJson(json[KEY_OWNER]);

    if (json[KEY_ACCOUNT] != null)
      account = _Account.fromJson(json[KEY_ACCOUNT]);
    else
      account = _Account.fromJson(Map<String, dynamic>());

    if (json[KEY_PROP_INFO] != null)
      propInfo = _PropInfo.fromJson(json[KEY_PROP_INFO]);
  }
}

class _PropInfo {
  num area;
  String boughtDate;
  num price;

  _PropInfo.fromJson(Map<String, dynamic> json){
    area = json[KEY_PROP_INFO_AREA] ?? 0.0;
    price = json[KEY_PROP_INFO_PRICE] ?? 0.0;
    boughtDate = json[KEY_PROP_INFO_DATE] ?? "";
  }
}

class _Account {
  String bankName;
  String accountNo;
  num money;
  num interest;
  num freezedMoney;
  num freezedInterest;
  List<_AccountLog> accountLog;

  _Account.fromJson(Map<String, dynamic> json) {
    bankName = json[KEY_ACCOUNT_BANK] ?? "";
    accountNo = json[KEY_ACCOUNT_NO] ?? "";
    money = json[KEY_ACCOUNT_MONEY] ?? ERROR_VALUE;
    freezedMoney = json[KEY_ACCOUNT_F_MONEY] ?? ERROR_VALUE;
    interest = json[KEY_ACCOUNT_INTEREST] ?? ERROR_VALUE;
    freezedInterest = json[KEY_ACCOUNT_F_INTEREST] ?? ERROR_VALUE;

    if (json[KEY_ACCOUNT_LOG] != null) {
      accountLog = List();
      List<dynamic> rawList = json[KEY_ACCOUNT_LOG];
      for ( dynamic rawData in rawList) {
        accountLog.add(_AccountLog.fromJson(rawData as Map<String, dynamic>));
      }

    }
  }
}

class _AccountLog {
  String time;
  String purpose;
  num money;

  _AccountLog.fromJson(Map<String, dynamic> json) {
    time = json[KEY_ACCOUNT_LOG_TIME] ?? "";
    try {
      if (time.isNotEmpty) {
        List<String> parts = time.split("-");
        time = parts[0] + "年" + parts[1] + "月" + parts[2] + "日";
      }
    } catch (e) {
      print("do nothing");
    }


    purpose = json[KEY_ACCOUNT_LOG_PURPOSE] ?? "";
    money = json[KEY_ACCOUNT_LOG_MONEY] ?? ERROR_VALUE;
  }

}

class _OwnerInfo {
  String name;
  String id;
  String tel;
  String email;

  _OwnerInfo.fromJson(Map<String, dynamic> json) {
    name = json[KEY_OWNER_NAME] ?? "";
    id = json[KEY_OWNER_ID] ?? "";
    tel = json[KEY_OWNER_TEL] ?? "";
    email = json[KEY_OWNER_EMAIL] ?? "";
  }
}