class Category {
  const Category({
    this.id,
    required this.title,
    required this.slug,
    this.description,
    this.icon,
    this.parentId,
  });

  final String? id;
  final String title;
  final String slug;
  final String? description;
  final String? icon;
  final String? parentId;
}
