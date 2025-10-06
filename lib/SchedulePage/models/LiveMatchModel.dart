
import 'package:intl/intl.dart';

class LiveNowMatchModel {
  final int? matchId;
  final String? team1;
  final String? team2;
  final String? venue;
  final String matchDate;
  final String matchTime;
  final String? category;
  final String? status;
  final String? sport;
  final String? active;
  final String? liveStreamUrl;
  final String set1Score1;
  final String set1Score2;
  final String set2Score1;
  final String set2Score2;
  final String set3Score1;
  final String set3Score2;
  final String set4Score1;
  final String set4Score2;
  final String set5Score1;
  final String set5Score2;

  // hockey
  final String team1Goals;
  final String team2Goals;

  // basketball
  final String team1Score;
  final String team2Score;

  // cricket
  final String? team1_score;
  final String? team1_wickets;
  final String? team2_score;
  final String? team2_wickets;
  final String team1_overs;
  final String team2_overs;

  final String first;
  final String second;
  final String third;
  final String athleteType;
  final String winner;
  final String loser;

  LiveNowMatchModel(
      {
        required this.matchId,
        required this.team1,
        required this.team2,
        required this.venue,
        required this.matchDate,
        required this.matchTime,
        required this.category,
        required this.status,
        required this.sport,
        required this.active,
        required this.liveStreamUrl,
        required this.set1Score1,
        required this.set1Score2,
        required this.set2Score1,
        required this.set2Score2,
        required this.set3Score1,
        required this.set3Score2,
        required this.set4Score1,
        required this.set4Score2,
        required this.set5Score1,
        required this.set5Score2,
        required this.team1Goals,
        required this.team2Goals,
        required this.team1Score,
        required this.team2Score,
        required this.team1_score,
        required this.team1_wickets,
        required this.team2_score,
        required this.team2_wickets,
        required this.team1_overs,
        required this.team2_overs,
        required this.first,
        required this.second,
        required this.third,
        required this.athleteType,
        required this.winner,
        required this.loser
      });

  factory LiveNowMatchModel.fromJson(Map<String, dynamic> json) {
    DateTime time = DateFormat('HH:mm:ss').parse(json['time'].toString());
    final date = DateTime.parse(json['date']??'2024-12-05').toLocal();
    final formattedDate = DateFormat('d MMMM').format(date); // Date format
    final formattedTime = DateFormat('h:mm a').format(time);   // Time format
    return LiveNowMatchModel(
        matchId: json['matchId'],
        team1: json['team1']??'',
        team2: json['team2']??'',
        venue: json['venue']??'',
        matchDate: formattedDate,
        matchTime: formattedTime,
        category: json['category']??'',
        status: json['status']??'',
        sport: json['sport']??'',
        active: (json['active']??0).toString(),
        liveStreamUrl: json['liveStreamUrl']??'',
        // tt + lt + volleyball
        set1Score1: (json['set1_score1']??0).toString(),
        set1Score2: (json['set1_score2']??0).toString(),
        set2Score1: (json['set2_score1']??0).toString(),
        set2Score2: (json['set2_score2']??0).toString(),
        set3Score1: (json['set3_score1']??0).toString(),
        set3Score2: (json['set3_score2']??0).toString(),
        set4Score1: (json['set4_score1']??0).toString(),
        set4Score2: (json['set4_score2']??0).toString(),
        set5Score1: (json['set5_score1']??0).toString(),
        set5Score2: (json['set5_score2']??0).toString(),
        // hockey
        team1Goals: (json['team1_goals']??0).toString(),
        team2Goals: (json['team2_goals']??0).toString(),
        // basketball
        team1Score: (json['team1_score']??0).toString(),
        team2Score: (json['team2_score']??0).toString(),
        // cricket
        team1_score: (json['team1_score']??0).toString(),
        team1_wickets: (json['team1_wickets']??0).toString(),
        team2_score: (json['team2_score']??0).toString(),
        team2_wickets: (json['team2_wickets']??0).toString(),
        team1_overs: (json['team1_overs']??0).toString(),
        team2_overs: (json['team2_overs']??0).toString(),
        first: json['first']??'',
        second:json['second']??'',
        third:json['third']??'',
        athleteType: json['athleteType']??'',
        winner: json['winner']??'',
        loser: json['loser']??""
    );
  }
}
