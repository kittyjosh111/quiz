enum QuestionCategory { ANIMALS, PLANTS, ANY }

extension QuestionCategoryExtension on QuestionCategory {
  String get title {
    String string = this.toString().toString().toLowerCase().split(".")[1];
    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }

  int get value {
    switch (this) {
      case QuestionCategory.ANIMALS:
        return 9;
      case QuestionCategory.PLANTS:
        return 10;
      default:
        return 0;
    }
  }
}
