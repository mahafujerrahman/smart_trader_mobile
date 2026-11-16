class PromoModel {
  final String id;
  final String title;
  final String imageUrl;
  final String link;
  final String? description;
  final String? type;

  const PromoModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.link,
    this.description,
    this.type,
  });

  String get fixedImageUrl {
    return imageUrl.replaceAll(
      'forex-images.instaforex.com',
      'forex-images.ifxdb.com',
    );
  }
}
