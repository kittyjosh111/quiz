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
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
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

    final Widget sliverAppBar = SliverAppBar(
      expandedHeight: size.height * 0.15,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          double appBarHeight =
              constraints.biggest.height; //getting AppBar height
          bool isExpanded =
              appBarHeight >= size.height * 0.12; //check if AppBar is expanded

          return AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            opacity: isExpanded ? 1 : 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.bottomLeft,
              padding: isExpanded
                  ? EdgeInsets.only(left: 16)
                  : EdgeInsets.only(
                      left: 16,
                      bottom: size.height * .15,
                    ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: Config().homeParagraph1,
                        style: TextStyle(
                            fontSize: Config().homeParagraph1FontSize,
                            color:
                                Theme.of(context).textTheme.headline2.color)),
                    TextSpan(
                      text: "\n" + "\n" + Config().homeParagraph2 + "\n",
                      style: TextStyle(
                          fontSize: Config().homeParagraph2FontSize,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

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
                    sliverAppBar,
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
