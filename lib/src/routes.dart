import 'package:angular_router/angular_router.dart';

import 'pages/login/login.template.dart' as login_template;
import 'pages/prop_list/prop_list.template.dart' as props_template;
import 'pages/entry/entry.template.dart' as entry_template;
import 'pages/prop_details/details.template.dart' as details_template;
import 'pages/pjt_apportion/apportion.template.dart' as apportion_template;
import 'pages/pjt_list/pjt_list.template.dart' as projects_template;
import 'pages/pjt_vote/pjt_vote.template.dart' as vote_template;
import 'pages/article_list/article_list.template.dart' as articles_template;

import 'route_paths.dart';

export 'route_paths.dart';

class Routes {
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory,
    useAsDefault: true,
  );

  static final props = RouteDefinition(
    routePath: RoutePaths.props,
    component: props_template.PropsComponentNgFactory,
  );

  static final entry = RouteDefinition(
    routePath: RoutePaths.entry,
    component: entry_template.EntryComponentNgFactory,
  );

  static final details = RouteDefinition(
    routePath: RoutePaths.details,
    component: details_template.DetailsComponentNgFactory,
  );

  static final projects = RouteDefinition(
    routePath: RoutePaths.projects,
    component: projects_template.ProjectListComponentNgFactory,
  );

  static final apportion = RouteDefinition(
    routePath: RoutePaths.apportion,
    component: apportion_template.ApportionComponentNgFactory,
  );

  static final vote = RouteDefinition(
    routePath: RoutePaths.vote,
    component: vote_template.VoteComponentNgFactory,
  );

  static final articleList = RouteDefinition(
    routePath: RoutePaths.articleList,
    component: articles_template.ArticleListNgFactory,
  );

  static final all = <RouteDefinition>[
    login,
    props,
    details,
    entry,
    vote,
    projects,
    apportion,
    articleList
  ];

}