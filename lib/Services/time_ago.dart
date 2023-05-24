class CountTimeAgo {
  final DateTime dateTime;

  CountTimeAgo(this.dateTime);

  String timeAgo() {
    Duration difference = DateTime.now().difference(dateTime);
    String timeAgo = '';
    double tempDataTime = 0.0;

    switch (difference.inDays) {
      case > 2200:
        timeAgo = "Too Old!";
        break;
      case > 365:
        tempDataTime = difference.inDays / 365;
        String count = tempDataTime.toStringAsFixed(1);
        double.tryParse(count)! <= 1 ? timeAgo = ('$count Year ago') : timeAgo = ('$count Years ago');
        break;
      case > 30:
        tempDataTime = difference.inDays / 30;
        String count = tempDataTime.toStringAsFixed(1);
        double.tryParse(count)! <= 1 ? timeAgo = ('$count Month ago') : timeAgo = ('$count Months ago');
        break;
      case > 0:
        tempDataTime = difference.inDays.toDouble();
        String count = tempDataTime.toStringAsFixed(1);
        double.tryParse(count)! <= 1 ? timeAgo = ('$count Day ago') : timeAgo = ('$count Days ago');
        break;
      default:
        if (difference.inHours > 0) {
          tempDataTime = difference.inHours.toDouble();
          String count = tempDataTime.toStringAsFixed(1);
          double.tryParse(count)! <= 1 ? timeAgo = ('$count Hour ago') : timeAgo = ('$count Hours ago');
        } else if (difference.inMinutes > 0) {
          tempDataTime = difference.inMinutes.toDouble();
          String count = tempDataTime.toStringAsFixed(1);
          double.tryParse(count)! <= 1 ? timeAgo = ('$count Minute ago') : timeAgo = ('$count Minutes ago');
        } else if (difference.inSeconds > 10) {
          timeAgo = "${(difference.inSeconds).round()} seconds ago";
        } else if (difference.inSeconds > 0 && difference.inSeconds < 10) {
          timeAgo = "Just now!";
        } else {
          timeAgo = "You should not be in the future yet ^^!";
        }
        break;
    }

    return timeAgo;
  }

/*
  String timeAgo() {
    Duration difference = DateTime.now().difference(dateTime);
    String timeAgo = '';
    double tempDataTime = 0.0;

    if (difference.inDays > 365) {
      tempDataTime = difference.inDays / 365;
      String count = tempDataTime.toStringAsFixed(1);
      double.tryParse(count)! <= 1 ? timeAgo = ('$count Year ago') : timeAgo = ('$count Years ago');
    } else if (difference.inDays > 30) {
      tempDataTime = difference.inDays / 30;
      String count = tempDataTime.toStringAsFixed(1);
      double.tryParse(count)! <= 1 ? timeAgo = ('$count Month ago') : timeAgo = ('$count Months ago');
    } else if (difference.inDays > 0) {
      tempDataTime = difference.inDays.toDouble();
      String count = tempDataTime.toStringAsFixed(1);
      double.tryParse(count)! <= 1 ? timeAgo = ('$count Day ago') : timeAgo = ('$count Days ago');
    } else if (difference.inHours > 0) {
      tempDataTime = difference.inHours.toDouble();
      String count = tempDataTime.toStringAsFixed(1);
      double.tryParse(count)! <= 1 ? timeAgo = ('$count Hour ago') : timeAgo = ('$count Hours ago');
    } else if (difference.inMinutes > 0) {
      tempDataTime = difference.inMinutes.toDouble();
      String count = tempDataTime.toStringAsFixed(1);
      double.tryParse(count)! <= 1 ? timeAgo = ('$count Minute ago') : timeAgo = ('$count Minutes ago');
    } else if (difference.inSeconds > 10) {
      timeAgo = "${(difference.inSeconds).round()} seconds ago";
    } else {
      timeAgo = "Just now!";
    }

    return timeAgo;
  }*/
}
