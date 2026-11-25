class Brand {
  const Brand({
    this.id,
    required this.title,
    required this.slug,
    this.description,
    this.icon,
  });

  final String? id;
  final String title;
  final String slug;
  final String? description;
  final String? icon;
}
