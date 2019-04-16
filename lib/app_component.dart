import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import 'package:route_play/src/route_paths.dart';
import 'package:route_play/src/routes.dart';

import 'package:route_play/src/data/local_store.dart' as store;

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styles: ['.active-route {color: #039be5}'],
  directives: [routerDirectives, coreDirectives, MaterialIconComponent],
  exports: [RoutePaths, Routes],
)


class AppComponent implements OnInit {

  AppComponent(this._router);
  Router _router;

  @override
  void ngOnInit() {
    window.onPopState.listen((PopStateEvent e) {
      if (store.prevLoc == store.Loc.entry)
        _router.navigate(Routes.login.toUrl());
      if (store.prevLoc == store.Loc.prop_list)
        _router.navigate(Routes.entry.toUrl());
      if (store.prevLoc == store.Loc.pjt_list) {
        if (store.properties.length > 1)
          _router.navigate(Routes.props.toUrl());
        else
          _router.navigate(Routes.entry.toUrl());
      }
    });
  }
}