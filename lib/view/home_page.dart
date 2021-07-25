import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/model/config.dart';
import 'package:quiz/model/quiz_category.dart';
import 'package:quiz/model/quiz_year.dart';
import 'package:quiz/service/quiz_customizer_cubit.dart';
import 'package:quiz/theme/ThemeItem.dart';
import 'package:quiz/view/customize_quiz_page.dart';
import 'package:quiz/widget/category_tile.dart';
import 'package:quiz/widget/feeling_lucky_button.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  AnimationController _animationController;
  bool _show = true;
  bool _loading = false;
  bool _loaded = false;
  bool _loadingConfig = false;
  bool _loadedConfig = false;
  bool _loadingYears = false;
  bool _loadedYears = false;

  /// Listen to scroll direction
  /// And hide and show fab animation direction
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_show) {
        _show = true;
        _animationController.forward();
      }
    } else {
      if (_show) {
        _show = false;
        _animationController.reverse();
      }
    }
  }

  ThemeItem _selectedItem;

  List<DropdownMenuItem<ThemeItem>> _dropDownMenuItems;

  List<DropdownMenuItem<ThemeItem>> buildDropdownMenuItems() {
    List<DropdownMenuItem<ThemeItem>> items = List();
    for (ThemeItem themeItem in ThemeItem.getThemeItems()) {
      items
          .add(DropdownMenuItem(value: themeItem, child: Text(themeItem.name)));
    }
    return items;
  }

  void changeColor() {
    DynamicTheme.of(context).setTheme(this._selectedItem.id);
  }

  onChangeDropdownItem(ThemeItem selectedItem) {
    setState(() {
      this._selectedItem = selectedItem;
    });
    changeColor();
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildDropdownMenuItems();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _scrollController.addListener(_scrollListener);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || !_loadedConfig || !_loadedYears) {
      if (!_loading) {
        _loading = true;
        QuestionCategory category = QuestionCategory();
        category
            .getCategories()
            .then((value) => setState(() {
                  _loaded = true;
                }))
            .onError((error, stackTrace) => () {
                  setState(() {
                    _loaded = true;
                  });
                });
      }
      if (!_loadingConfig) {
        _loadingConfig = true;
        Config config = Config();
        config
            .loadConfig()
            .then((value) => setState(() {
                  _loadedConfig = true;
                }))
            .onError((error, stackTrace) => () {
                  setState(() {
                    _loadedConfig = true;
                  });
                });
      }
      if (!_loadingYears) {
        _loadingYears = true;
        QuestionYear year = QuestionYear();
        year
            .getYears()
            .then((value) => setState(() {
                  _loadedYears = true;
                }))
            .onError((error, stackTrace) => () {
                  setState(() {
                    _loadedYears = true;
                  });
                });
      }
      return new Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                "Welcome to",
                style: Theme.of(context).textTheme.headline6,
                maxLines: 2,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: AutoSizeText(
                    "USABO/biology Quiz",
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 2,
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: AutoSizeText(
                    "questions reused with permission from",
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 2,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: new Image.asset('assets/images/cee.png'),
              )
            ],
          ),
        ),
      );
    }
    QuestionCategory category = QuestionCategory();
    //category.getCategories().then((value) => _loading = false);
    final Size size = MediaQuery.of(context).size;
    QuizCustomizerCubit quizCustomizer =
        BlocProvider.of<QuizCustomizerCubit>(context);
    List<QuestionCategoryExtension> categories =
        category.getCategoriesImmediate();

    /// Returns the MaxCrossAxisExtend value according to the orientation
    double getMaxCrossAxisExtend() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      Size size = mediaQueryData.size;

      if (size.height > size.width) {
        return mediaQueryData.size.width / 1.5;
      } else {
        return mediaQueryData.size.height / 2.5;
      }
    }

    final VoidCallback feelingLuckyButtonOnPressed = () {
      quizCustomizer.selectCategory(0);
    };

    return BlocConsumer<QuizCustomizerCubit, AbstractQuizCustomizerState>(
      bloc: quizCustomizer,
      listener: (context, state) {
        if (state.runtimeType == QuizCategoryChosenState) {
          Navigator.of(context).pushNamed(CustomizeQuizPage.routeName);
        }
      },
      builder: (context, state) {
        return Material(
          child: Scaffold(
            appBar: AppBar(
              //title: Text(Config().homeTitleText),
              title: FittedBox(
                  fit: BoxFit.cover, child: Text(Config().homeTitleText)),
              actions: <Widget>[
                DropdownButton(
                  icon: Icon(Icons.palette, color: Colors.white),
                  items: _dropDownMenuItems,
                  onChanged: onChangeDropdownItem,
                  underline: SizedBox(),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            floatingActionButton: FeelingLuckyButton(
              onPressed: feelingLuckyButtonOnPressed,
              animationController: _animationController,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            Config().homeParagraph1,
                            style: TextStyle(
                                fontSize: Config().homeParagraph1FontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                            maxLines: 2,
                          ),
                          AutoSizeText(
                            "\n" + Config().homeParagraph2,
                            style: TextStyle(
                                fontSize: Config().homeParagraph2FontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: getMaxCrossAxisExtend(),
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => CategoryTile(
                          questionCategory: categories[index],
                          onTap: () {
                            //print("selected category index $index");
                            quizCustomizer.selectCategory(index + 1);
                          },
                        ),
                        childCount: categories.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
