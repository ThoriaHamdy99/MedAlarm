import 'user.dart';
import 'message.dart';

class Contact {
  final User user;
  final Message latestMsg;

  Contact(this.user, this.latestMsg);
}