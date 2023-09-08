class ListItem {
  String text;
  bool isChecked;
  String id;

  ListItem({
    required this.text,
    required this.isChecked,
    required this.id,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      text: json['title'],
      isChecked: json['isChecked'],
      id: json['id'],
    );
  }
}
