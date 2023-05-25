class CountTimeAgo {
  final DateTime dateTime;

  CountTimeAgo(this.dateTime);

  String _afterDot({required double tempDateTime, required String type}) {
    String timeAgo = '';
    String count = tempDateTime.toStringAsFixed(1);
    double.tryParse(count)! <= 1
        ? timeAgo = ('${count.split('.')[1].contains('0') ? count.split('.')[0] : count} $type ago')
        : timeAgo = ('${count.split('.')[1].contains('0') ? count.split('.')[0] : count} ${'${type}s '}ago');

    return timeAgo;
  }

  String timeAgo() {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 3650) {
      return "Too Old!";
    } else if (difference.inDays > 365) {
      return _afterDot(tempDateTime: difference.inDays / 365, type: 'Year');
    } else if (difference.inDays > 30) {
      return _afterDot(tempDateTime: difference.inDays / 30, type: 'Month');
    } else if (difference.inDays > 0) {
      return _afterDot(tempDateTime: difference.inDays.toDouble(), type: 'Day');
    } else if (difference.inHours > 0) {
      return _afterDot(tempDateTime: difference.inHours.toDouble(), type: 'Hour');
    } else if (difference.inMinutes > 0) {
      return _afterDot(tempDateTime: difference.inMinutes.toDouble(), type: 'Minute');
    } else if (difference.inSeconds > 10) {
      return _afterDot(tempDateTime: difference.inSeconds.toDouble(), type: 'Sec');
    } else if (difference.inSeconds > 0 && difference.inSeconds < 10) {
      return "Just now";
    } else {
      return "You attend in future!";
    }
  }
}
