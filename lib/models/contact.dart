import 'user.dart';
import 'message.dart';

class Contact {
  final User user;
  final Message latestMsg;
  // final String lastMsgDate;

  // Contact(this.user, {this.lastMsgDate});
  Contact(this.user, this.latestMsg);
}