import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/animation/category_tile_animation.dart';
import 'package:quiz/model/quiz_category.dart';

class CategoryTile extends StatelessWidget {
  final QuestionCategoryExtension _questionCategory;
  final VoidCallback _onTap;

  const CategoryTile(
      {@required QuestionCategoryExtension questionCategory,
      @required VoidCallback onTap,
      Key key})
      : this._questionCategory = questionCategory,
        this._onTap = onTap,
        assert(questionCategory != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryTileAnimation(
      child: InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(Base64Decoder()
                          .convert(_questionCategory.base64Image))
                      .image,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
                child: FittedBox(
                  alignment: Alignment.bottomRight,
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 12, right: 8),
                      child: Text(
                        "${_questionCategory.title.toUpperCase()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
