import 'package:intl/intl.dart';

class UpcomingMatchesModel {
  final int matchId;
  final String team1;
  final String team2;
  final String matchDate;
  final String matchTime;
  final String venue;
  final String sport;
  final String category;
  final double delayMinutes;
  final String athleteType;

  UpcomingMatchesModel(
      {
        required this.matchId,
        required this.team1,
        required this.team2,
        required this.matchDate,
        required this.matchTime,
        required this.venue,
        required this.sport,
        required this.category,
        this.delayMinutes = 0,
        required this.athleteType
      });

  factory UpcomingMatchesModel.fromJson(Map<String, dynamic> json) {
    DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString()).toLocal();
    final date = DateTime.parse(json['date']??'2024-11-05').toLocal();
    DateTime combinedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second,);
    int matchTimestamp = combinedDateTime.millisecondsSinceEpoch;
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final formattedDate = DateFormat('d MMM').format(date);
    final formattedTime = DateFormat('h:mm a').format(time);
    return UpcomingMatchesModel(
      matchId: json['matchId']??-1,
      team1: json['team1']??'',
      team2: json['team2']??'',
      matchDate: formattedDate,
      matchTime: formattedTime,
      venue: json['venue']??'',
      sport: json['sport']??'',
      category: json['category']??'',
      delayMinutes: ((currentTimestamp-matchTimestamp) / 60000),
        athleteType: json['athleteType']??''
    );
  }
}