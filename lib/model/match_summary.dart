class MatchSummaryModel {
  final int id;
  final String tournament_name;
  final String team1_name;
  final String team1_short_name;
  final String team1_url;
  final String team2_name;
  final String team2_short_name;
  final String team2_url;
  final String team1_innings_1;
  final String team2_innings_1;
  final String team1_innings_2;
  final String team2_innings_2;
  final String match_status;
  final String tag;
  final String tag_color;

  MatchSummaryModel(
    this.id,
    this.tournament_name,
    this.team1_name,
    this.team1_short_name,
    this.team1_url,
    this.team2_name,
    this.team2_short_name,
    this.team2_url,
    this.team1_innings_1,
    this.team2_innings_1,
    this.team1_innings_2,
    this.team2_innings_2,
    this.match_status,
    this.tag,
    this.tag_color
  );
}
