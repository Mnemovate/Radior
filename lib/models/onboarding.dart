class Onboarding {
  final String image;
  final String title;
  final String description;

  Onboarding({
    required String image,
    required this.title,
    required this.description,
  })  : image = "assets/images/onboarding/$image.svg";
}