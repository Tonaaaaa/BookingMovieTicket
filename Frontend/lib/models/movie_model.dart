class Movie {
  final int id;
  final String title;
  final String description;
  final List<String> actors;
  final int like;
  final String bannerUrl;
  final List<String> screens;
  final String releaseDate;
  final List<String> userVotes;
  final String duration;
  final List<String> genres;
  final int votes;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.actors,
    required this.like,
    required this.bannerUrl,
    required this.screens,
    required this.releaseDate,
    required this.userVotes,
    required this.duration,
    required this.genres,
    required this.votes,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0, // Giá trị mặc định nếu `id` là null
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      actors: (json['actors'] != null) ? List<String>.from(json['actors']) : [],
      like: json['like'] ?? 0,
      bannerUrl: json['bannerUrl'] ?? '',
      screens:
          (json['screens'] != null) ? List<String>.from(json['screens']) : [],
      releaseDate: json['releaseDate'] ?? '',
      userVotes: (json['userVotes'] != null)
          ? List<String>.from(json['userVotes'])
          : [],
      duration: json['duration'] ?? '',
      genres: (json['genres'] != null) ? List<String>.from(json['genres']) : [],
      votes: json['votes'] ?? 0,
    );
  }
}
