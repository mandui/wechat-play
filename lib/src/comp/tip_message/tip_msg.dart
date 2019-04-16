import 'package:angular/angular.dart';
import 'package:ng_fontawesome/ng_fontawesome.dart';

@Component (
  selector: 'tip-msg',
  templateUrl: 'tip_msg.html',
  styleUrls: ['tip_msg.css'],
  directives: [ NgIf, coreDirectives, FaIcon ]
)

class TipMessage {

  @Input()
  String desc;

  @Input()
  bool isLoading;

  @Input()
  bool tipOn;

}
