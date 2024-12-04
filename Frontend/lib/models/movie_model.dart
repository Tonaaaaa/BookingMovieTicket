import 'package:bookingmovieticket/models/actor_model.dart';

class Movie {
  final int id;
  final String title;
  final String? description;
  final String? bannerUrl;
  final DateTime releaseDate;
  final int durationInMinutes;
  final List<String> genres;
  final int like;
  final String status;
  final String? trailerUrl;
  final List<Actor> actors;
  final String? ageRating;
  final List<String> formats;
  final List<String> languagesAvailable;

  Movie({
    required this.id,
    required this.title,
    this.description,
    this.bannerUrl,
    required this.releaseDate,
    required this.durationInMinutes,
    required this.genres,
    required this.like,
    required this.status,
    this.trailerUrl,
    required this.actors,
    this.ageRating,
    required this.formats,
    required this.languagesAvailable,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String? bannerUrl =
        json['BannerUrl']?.replaceFirst('localhost', '10.0.2.2');
    String? trailerUrl =
        json['TrailerUrl']?.replaceFirst('localhost', '10.0.2.2');

    return Movie(
      id: json['Id'],
      title: json['Title'] ?? 'Unknown',
      description: json['Description'],
      bannerUrl: bannerUrl != null ? Uri.encodeFull(bannerUrl) : null,
      releaseDate:
          DateTime.tryParse(json['ReleaseDate'] ?? '') ?? DateTime.now(),
      durationInMinutes: json['DurationInMinutes'] ?? 0,
      genres: List<String>.from(json['Genres'] ?? []),
      like: json['Like'] ?? 0,
      status: json['Status'] ?? 'Inactive',
      trailerUrl: trailerUrl != null ? Uri.encodeFull(trailerUrl) : null,
      actors: (json['Actors'] as List?)
              ?.map((actorJson) => Actor.fromJson(actorJson))
              .toList() ??
          [],
      ageRating: json['AgeRating'],
      formats: List<String>.from(json['Formats'] ?? []),
      languagesAvailable: List<String>.from(json['LanguagesAvailable'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Description': description,
      'BannerUrl': bannerUrl,
      'ReleaseDate': releaseDate.toIso8601String(),
      'DurationInMinutes': durationInMinutes,
      'Genres': genres,
      'Like': like,
      'Status': status,
      'TrailerUrl': trailerUrl,
      'Actors': actors.map((actor) => actor.toJson()).toList(),
      'AgeRating': ageRating,
      'Formats': formats,
      'LanguagesAvailable': languagesAvailable,
    };
  }
}
