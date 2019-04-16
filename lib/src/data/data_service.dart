import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/data/project.dart';
import 'package:route_play/src/data/local_store.dart' as store;

const PARAM_ACCOUNT_NO = "ACCOUNT_NO";
const PARAM_ACCOUNT_ID = "ACCOUNT_ID";
const PARAM_ACCOUNT_PSW = "PASSWORD";
const PARAM_PJT_NO = "PROJECT_NO";
const PARAM_VOTE_TYPE = "VOTE_TYPE";
const PARAM_VOTE_DESC = "VOTE_DESC";
const PARAM_AUTH_TYPE = "AUTH_TYPE";
const PARAM_USER_NAME = "NAME";
const PARAM_USER_ID = "ID_NO";
const KEY_ERROR_MSG = "ERRORMSG";


class DataService {

  var errorMsg;
  final timeout = 20;
  final _errTimeout = "抱歉，与服务器连接超时，烦请稍后再试。";
  final _errDecode = "抱歉，数据解析出错。";
  final _errNull = "在此项目下并无数据。";
  final _errAgain = "非常抱歉，提交不成功，请等待15s后再试。";

  static final _auth = "http://192.168.2.110:8090/rsfmpwf/wfPort/logincheck";
  final _propAPI = _auth + "/v1.0/postLoginCheck";
  final _pjtAPI =  _auth + "/v2.0/postProject";
  final _aptAPI =  _auth + "/v3.0/postShare";
  final _voteAPI = _auth + "/v4.0/updateShare";
  final exprUrl = "http://localhost:4040";


  Map<String, String> _headers = {
    'Content-type' : 'application/json',
    'cache-control': "no-cache",
  };

  Future<Map<String, dynamic>> authorize(Map<String, dynamic> params) async {

    Map<String, dynamic> map = await _getDataMap(_propAPI, params);

    try {
      if (map.containsKey(KEY_PROP_LIST)) {
        List<Property> properties = List();
        List<dynamic> list = map[KEY_PROP_LIST];

        int count = 0;
        for (dynamic propData in list) {
          Property prop = Property.fromJson(propData as Map<String,dynamic>);
          prop.index = count.toString();
          properties.add(prop);
          count ++;
        }
        print(properties.length);
        Map<String, dynamic> retMap = Map();
        retMap[KEY_PROP_LIST] = properties;
        return await retMap;
      }
    } catch (e) {
      // todo send error log
      _sendErrorReport("");
      return { KEY_ERROR_MSG: _errDecode };
    }

    return map;
  }

  Future<Map<String, dynamic>> fetchProjects(String accountNo) async {

    if (store.debug) return _mockProjectList(accountNo);

    // for real
    Map<String, String> params = { PARAM_ACCOUNT_NO: accountNo };

    Map<String, dynamic> data = await _getDataMap(_pjtAPI, params);

    List<dynamic> pjtData = data[KEY_PJT];
    try {
      if (pjtData == null || pjtData.isEmpty) {
        return { KEY_ERROR_MSG: _errNull };
      } else {

        List<Project> pjtList = List();
        for (Map pjt in pjtData) {
          final project = Project(accountNo);
          project.assignValues(pjt);
          pjtList.add(project);
        }

        return { KEY_PJT : pjtList };
      }

    } catch(e) {
      // todo add a api to log error
      _sendErrorReport("");
      return { KEY_ERROR_MSG: _errDecode };
    }
  }

  Future<Map<String, dynamic>> fetchApportionLog(String projectNo) async {

    if (store.debug) return _mockAppList(projectNo);

    // for real
    Map<String, String> params = { PARAM_PJT_NO: projectNo };
    Map<String, dynamic> data = await _getDataMap(_aptAPI, params);

    try {
      List<dynamic> aptData = data[KEY_APT];
      if (aptData.isEmpty) {
        return { KEY_ERROR_MSG: _errNull};
      } else {
        List<ApportionItem> aptList = List();
        for (Map item in aptData) {
          final aptItem = ApportionItem.fromJson(item);
          aptList.add(aptItem);
        }
        return { KEY_APT : aptList };
      }

    } catch(e) {
      // todo send error log
      _sendErrorReport("");
      return { KEY_ERROR_MSG: _errDecode };
    }
  }

  Future<Map<String, dynamic>> sendOpinion(String opinion) async {

    if (store.debug) return Future.delayed(Duration(seconds: 3), () => { KEY_ERROR_MSG: "" });

    // for real
    String pjtNo = store.currPjtNo;
    String accNo = store.currentProperty.account.accountNo;
    final params = {
      PARAM_PJT_NO: pjtNo, PARAM_ACCOUNT_NO: accNo,
      PARAM_VOTE_TYPE: "", PARAM_VOTE_DESC: opinion};
    final response = await http.post(_voteAPI, headers: _headers, body: json.encode(params))
      .timeout(Duration(seconds: timeout), onTimeout : () => null);

    if (response == null) return {
      KEY_ERROR_MSG: _errTimeout
    };

    Map<String, dynamic> data = await json.decode(response.body);
    if ( data == null || !data.containsKey(KEY_ERROR_MSG)) {
      return { KEY_ERROR_MSG: _errAgain };
    } else {
      return data;
    }
  }

  Future<Map<String, dynamic>> sendVote(String voteType) async {
    if (store.debug) return Future.delayed(Duration(seconds: 3), () => { KEY_ERROR_MSG: "" });

    // for real
    String pjtNo = store.currPjtNo;
    String accNo = store.currentProperty.account.accountNo;
    final params = {
      PARAM_PJT_NO: pjtNo, PARAM_ACCOUNT_NO: accNo,
      PARAM_VOTE_TYPE: voteType, PARAM_VOTE_DESC: ""};
    final response = await http.post(_voteAPI, headers: _headers, body: json.encode(params))
        .timeout(Duration(seconds: timeout), onTimeout : () => null);

    if (response == null) return {
      KEY_ERROR_MSG: _errTimeout
    };

    Map<String, dynamic> data = await json.decode(response.body);
    if ( data == null || !data.containsKey(KEY_ERROR_MSG)) {
      return { KEY_ERROR_MSG: _errAgain };
    } else {
      return data;
    }
  }

  Future<bool> fetchArticles() {

  }

  Future<String> _getAccessToken() async {
    // https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET


  }

  void _sendErrorReport(String error) {}

  Future<Map<String, dynamic>> _getDataMap(String api, Map<String, dynamic> params) async {

    final response = await http.post(api, headers: _headers, body: json.encode(params))
        .timeout(Duration(seconds: timeout), onTimeout : () => null);

    if (response == null) return { KEY_ERROR_MSG: _errTimeout };

    Map<String, dynamic> map = await json.decode(response.body);

    if (map == null || map.isEmpty) return { KEY_ERROR_MSG: _errNull};

    return map;
  }

  /// Test Function returns Mock Data /// /// Test Function returns Mock Data ///
  /// Test Function returns Mock Data /// /// Test Function returns Mock Data ///


  Future<Map<String, String>> testErrorAccount()
  => Future.delayed(_threeSeconds, () => _mockAccountError);

  Future<Map<String, String>> testErrorId()
  => Future.delayed(_threeSeconds, () => _mockIdError);

  Future<Map<String, dynamic>> testTimeout() {
    final ret = { KEY_PROP_LIST: [_mockOneProp()] };
    return Future.delayed(_fifteenSeconds, () => ret);
  }

  Future<Map<String, dynamic>> testOneProp() {
    final ret = { KEY_PROP_LIST: [_mockOneProp()] };
    return Future.delayed(_threeSeconds, () => ret);
  }

  Future<Map<String, dynamic>> testMultiProps() {
    final ret = { KEY_PROP_LIST: _mockMultiProps() };
    return Future.delayed(_threeSeconds, () => ret);
  }

  final _threeSeconds = Duration(seconds: 3);
  final _fifteenSeconds = Duration(seconds: 15);
  Property _mockOneProp() => Property.fromJson(jsonProp1);

  List<Property> _mockMultiProps()
    => [ Property.fromJson(jsonProp1),
         Property.fromJson(jsonProp2) ];

  Future<Map<String, dynamic>> _mockAppList(String projectNo) {
    List<ApportionItem> aptList = List();
    for (int i = 0; i < 20; i++) {
      aptList.add(ApportionItem.fromJson(jsonApportionItem));
    }

    return Future.delayed(Duration(seconds: 2), () => {KEY_APT: aptList});
  }

  Future<Map<String, dynamic>> _mockProjectList(String accountNo) {
    List<Project> pjtList = List();
    final project1 = Project(accountNo);
    project1.assignValues(jsonPjt1);
    final project2 = Project(accountNo);
    project2.assignValues(jsonPjt2);
    pjtList.add(project1);
    pjtList.add(project2);
    return Future.delayed(Duration(seconds: 2), () => {KEY_PJT: pjtList});
  }

  final _mockAccountError = {
    KEY_ERROR_MSG: "账号或密码有误，请检查后再次输入。"
  };
  final _mockIdError = {
    KEY_ERROR_MSG: "查询不到该身份证名下房产信息，请检查后再次输入。"
  };

  Map<String, dynamic> jsonPjt1 = {
    KEY_PJT_NO: "PJT-12359343",
    KEY_PJT_NAME: "1204与1205厕所漏水，影响生活。",
    KEY_PJT_DESC: "1204与1205厕所漏水，影响生活，实际它很长很长很长很长很长很长，大概这么长。",
    KEY_PJT_APT_TYPE: "单元分摊",
    KEY_PJT_VOTABLE: "TRUE",
    KEY_PJT_AREA: 134.2,
    KEY_PJT_MONEY: 1344.5,
    KEY_PJT_TOTAL_MONEY: 9788.4,
    KEY_PJT_TOTAL_OWNER: 9,
    KEY_PJT_TOTAL_AREA: 4300,
    KEY_PJT_BUDGET: 9788.4,
    KEY_PJT_DEADLINE: "2019-5-2"
  };

  Map<String, dynamic> jsonPjt2 = {
    KEY_PJT_NO: "PJT-12359346",
    KEY_PJT_NAME: "1204与1205厕所漏水，影响生活。",
    KEY_PJT_DESC: "1204与1205厕所漏水，影响生活，实际它很长很长很长很长很长很长，大概这么长。",
    KEY_PJT_APT_TYPE: "单元分摊",
    KEY_PJT_VOTABLE: "TRUE",
    KEY_PJT_AREA: 134.2,
    KEY_PJT_MONEY: 1344.5,
    KEY_PJT_TOTAL_MONEY: 9788.4,
    KEY_PJT_TOTAL_OWNER: 9,
    KEY_PJT_TOTAL_AREA: 4300,
    KEY_PJT_BUDGET: 9788.4,
    KEY_PJT_DEADLINE: "2019-5-2"
  };

  Map<String, dynamic> jsonApportionItem = {
    KEY_APT_LOCATION: "45号楼2单元102室",
    KEY_APT_MONEY: 947.1,
    KEY_APT_AREA: 134.44
  };

  Map<String, dynamic> jsonProp1 = {
    KEY_OWNER : {
      KEY_OWNER_NAME: "某某", KEY_OWNER_TEL: "13800138000",
      KEY_OWNER_ID: "123456123456781234", KEY_OWNER_EMAIL: ""
    },
    KEY_PROP_ID: "SOME_MD5_STR",
    KEY_PROP_INFO: {
      KEY_PROP_INFO_DATE: "", KEY_PROP_INFO_AREA: 190.24, KEY_PROP_INFO_PRICE: 0
    },
    KEY_PROP_ADDR: "潍坊市奎文区中xx馨苑xx号楼x单元xxx室",
    KEY_ACCOUNT: {
      KEY_ACCOUNT_F_MONEY: 0,
      KEY_ACCOUNT_MONEY: 17121,
      KEY_ACCOUNT_F_INTEREST: 0,
      KEY_ACCOUNT_INTEREST: 0,
      KEY_ACCOUNT_NO: "00123456789",
      KEY_ACCOUNT_BANK: "招商银行潍坊分行",
      KEY_ACCOUNT_LOG: [
        {
          KEY_ACCOUNT_LOG_TIME: "2019-01-03",
          KEY_ACCOUNT_LOG_MONEY: 17121,
          KEY_ACCOUNT_LOG_PURPOSE: "业主交存"
        }
      ]
    }
  };

  Map<String, dynamic> jsonProp2 = {
    KEY_OWNER : {
      KEY_OWNER_NAME: "李某，王某某", KEY_OWNER_TEL: "",
      KEY_OWNER_ID: "123456123456781234", KEY_OWNER_EMAIL: ""
    },
    KEY_PROP_ID: "SOME_MD5_STR",
    KEY_PROP_INFO: {
      KEY_PROP_INFO_DATE: "", KEY_PROP_INFO_AREA: 141.89, KEY_PROP_INFO_PRICE: 0
    },
    KEY_PROP_ADDR: "潍坊市高新开发区xx花园x号楼x单元xxxx室",
    KEY_ACCOUNT: {
      KEY_ACCOUNT_F_MONEY: 0,
      KEY_ACCOUNT_MONEY: 12770.0,
      KEY_ACCOUNT_F_INTEREST: 0,
      KEY_ACCOUNT_INTEREST: 1287.44,
      KEY_ACCOUNT_NO: "00123456789",
      KEY_ACCOUNT_BANK: "潍坊银行",
      KEY_ACCOUNT_LOG: [
        {
          KEY_ACCOUNT_LOG_TIME: "2014-02-21",
          KEY_ACCOUNT_LOG_MONEY: 12770.0,
          KEY_ACCOUNT_LOG_PURPOSE: "资金交存"
        },
        {
          KEY_ACCOUNT_LOG_TIME: "2014-12-20",
          KEY_ACCOUNT_LOG_MONEY: 323.28,
          KEY_ACCOUNT_LOG_PURPOSE: "资金结息"
        },
        {
          KEY_ACCOUNT_LOG_TIME: "2014-12-20",
          KEY_ACCOUNT_LOG_MONEY: 363.46,
          KEY_ACCOUNT_LOG_PURPOSE: "资金结息"
        },
        {
          KEY_ACCOUNT_LOG_TIME: "2014-12-20",
          KEY_ACCOUNT_LOG_MONEY: 352.41,
          KEY_ACCOUNT_LOG_PURPOSE: "资金结息"
        },
        {
          KEY_ACCOUNT_LOG_TIME: "2014-12-20",
          KEY_ACCOUNT_LOG_MONEY: 248.29,
          KEY_ACCOUNT_LOG_PURPOSE: "资金结息"
        },
      ]
    }
  };
}