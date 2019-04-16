import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:route_play/src/route_paths.dart';
import 'package:route_play/src/routes.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:route_play/src/data/data_service.dart';
import 'package:route_play/src/data/local_store.dart' as store;
import 'package:route_play/src/data/property.dart';
import 'package:route_play/src/comp/tip_message/tip_msg.dart';

@Component (
  selector: 'my-login',
  templateUrl: "index.html",
  styleUrls: ["login.css", "from_n.css"],
  directives: [routerDirectives, coreDirectives, formDirectives, FaIcon, NgIf, NgClass, TipMessage],
  exports: [RoutePaths, Routes],
)


class LoginComponent implements OnInit{

  @override
  void ngOnInit() {
    querySelector("title").text = "请登录维修资金查询系统";
    // clear local store in case user back to this page
    store.reset();
  }

  LoginComponent(this._router);
  final Router _router;

  String switchTo = "使用身份证信息查询";
  String errorMsg = "";
  String printMsg = "";

  bool hideId = true;
  bool hideAccount = false;

  dynamic inputId;
  dynamic inputAccount;
  String inputPsw;
  String inputName;
  bool validatedId = true;
  bool validatedAccount = true;
  bool validatedPsw = true;
  bool validatedName = true;

  void auth() async {
    final params = _validate();
    if (params != null) {
      tipLoading = true;
      Map<String, dynamic> retMap;
      try {
        retMap = await _service.authorize(params)
            .timeout(Duration(seconds: 30), onTimeout : () => {
          KEY_ERROR_MSG: "抱歉，与服务器连接超时，烦请稍后再试。"
        });
      } catch (e) {
        retMap = {
          KEY_ERROR_MSG : "抱歉，未能取得查询结果，烦请稍后再试。"
        };
      }

      List<Property> propList = retMap[KEY_PROP_LIST];
      if (propList != null && propList.isNotEmpty) {
        store.properties = propList;
        if (propList.length == 1) store.currentProperty = propList[0];
        tipLoading = false; tipError = false;

        await _gotoEntry();

      } else {
        if (retMap.containsKey(KEY_ERROR_MSG))
          errorMsg = retMap[KEY_ERROR_MSG];
        else
          errorMsg = "抱歉，未能取得查询结果，烦请稍后再试。";

        tipLoading = false; tipError = true;
      }
    }
  }

  /// used when user change login method ///
  void changeMode() {
    _clearInputContents();
    hideId = !hideId;
    hideAccount = !hideAccount;

    switchTo = hideAccount ? "使用账号信息查询" : "使用身份证信息查询";
  }

  void nameClick() { validatedName = true; }
  void idClick() { validatedId = true; }
  void pswClick() { validatedPsw = true; }
  void accountClick() { validatedAccount = true; }

  /// util functions ///
  bool tipLoading = false;
  bool tipError = false;

  void _clearInputContents() {
    validatedAccount = true;
    validatedId = true;
    validatedPsw = true;
    validatedName = true;

    inputId = null;
    inputAccount = null;
    inputPsw = null;
    inputName = null;
  }

  Map<String, String> _validate() {
    if (hideAccount) return _validateId();
    if (hideId) return _validateAccount();

    return null;
  }

  Map<String, String> _validateAccount() {
    String accountStr = inputAccount?.toString();
    if (accountStr == null || accountStr.isEmpty)
      validatedAccount = false;
    if (inputPsw == null || inputPsw.isEmpty)
      validatedPsw = false;

    //print("account: $accountStr");
    //print("password: $inputPsw");

    if (!validatedAccount || !validatedPsw) return null;

    // todo change later
    String cAccount = _encryptString(accountStr, "some key");
    String cPsw = _encryptString(inputPsw, "some key");

    final body = {
      PARAM_AUTH_TYPE: "account",
      PARAM_ACCOUNT_ID: cAccount,
      PARAM_ACCOUNT_PSW: cPsw
    };
    return body;
  }

  Map<String, String> _validateId() {
    String idStr = inputId?.toString();
    if (inputName == null || inputName.isEmpty)
      validatedName = false;
    if (idStr == null || idStr.length != 18)
      validatedId = false;

    print("name: $inputName");
    print("id: $idStr");

    if (!validatedId || !validatedName) return null;

    // todo change later
    String cId = _encryptString(idStr, "some key");
    String cName = _encryptString(inputName, "some key");
    final body = {
      PARAM_AUTH_TYPE: "id",
      PARAM_USER_ID: cId,
      PARAM_USER_NAME: cName
    };
    return body;
  }

  // todo use some encrypt method
  String _encryptString(String word, String key) {
    var bytes = utf8.encode(word); // data being hashed
    var hashed = md5.convert(bytes);

    String encrypted = hashed.toString();

    encrypted = word;
    return encrypted;
  }

  /// test part ///
  DataService _service = DataService();
  void test(String which) async {
    // clear local store in case user back to this page
    store.properties = null;
    store.currentProperty = null;

    print(which);
    tipLoading = true;
    Map<String, dynamic> retMap = await _getMockResult(which)
        .timeout(Duration(seconds: 5), onTimeout : () => {
          KEY_ERROR_MSG: "抱歉，与服务器连接超时，烦请稍后再试。"
    });

    print(retMap);
    List<Property> propList = retMap[KEY_PROP_LIST];
    if (propList != null && propList.isNotEmpty) {
      store.properties = propList;
      if (propList.length == 1) store.currentProperty = propList[0];
      tipLoading = false; tipError = false;

      await _gotoEntry();

    } else {
      if (retMap.containsKey(KEY_ERROR_MSG))
        errorMsg = retMap[KEY_ERROR_MSG];
      else
        errorMsg = "抱歉，未能取得查询结果，烦请稍后再试。";

      tipLoading = false; tipError = true;
    }

  }

  Future _getMockResult(String which) {
    switch(which) {
      case "account_err":
        return _service.testErrorAccount();
      case "account_correct":
        return _service.testOneProp();
      case "id_err":
        return _service.testErrorId();
      case "id_correct":
        return _service.testOneProp();
      case "one_prop":
        return _service.testOneProp();
      case "multi_prop":
        return _service.testMultiProps();
      case "timeout":
        return _service.testTimeout();
      default:
        return _service.testTimeout();
    }
  }

  Future<NavigationResult> _gotoEntry() =>
      _router.navigate(Routes.entry.toUrl());

}
