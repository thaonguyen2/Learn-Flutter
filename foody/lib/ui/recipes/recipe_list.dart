import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_dropdown.dart';
import '../colors.dart';
import 'dart:convert';
import '../../network/recipe_model.dart';
import 'package:flutter/services.dart';
import '../recipe_card.dart';
import 'recipe_details.dart';
import '../../network/recipe_service.dart';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import '../../network/model_response.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';
  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];

  List<APIHits> currentSearchList = [];

//   Future loadRecipes() async {
//     // 1
//     final jsonString = await rootBundle.loadString('assets/recipes1.json');
//     setState(() {
// // 2
//       _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
//     });
//   }

//   Future<APIRecipeQuery> getRecipeData(String query, int from, int to) async {
// // 2
//     final recipeJson = await RecipeService().getRecipes(query, from, to);
// // 3
//     final recipeMap = json.decode(recipeJson);
//     // 4
//     return APIRecipeQuery.fromJson(recipeMap);
//   }

  @override
  void initState() {
    super.initState();

    getPreviousSearches();

    searchTextController = TextEditingController(text: '');
    _scrollController.addListener(() {
      final triggerFetchMoreSize =
          0.7 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        if (hasMore &&
            currentEndPosition < currentCount &&
            !loading &&
            !inErrorState) {
          setState(() {
            loading = true;
            currentStartPosition = currentEndPosition;
            currentEndPosition =
                min(currentStartPosition + pageCount, currentCount);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    // 1
    final prefs = await SharedPreferences.getInstance();
    // 2
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    // 1
    final prefs = await SharedPreferences.getInstance();
    // 2
    if (prefs.containsKey(prefSearchKey)) {
// 3
      final searches = prefs.getStringList(prefSearchKey);
      // 4
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            // Replace
            IconButton(
              icon: const Icon(Icons.search),
              // 1
              onPressed: () {
// 2
                startSearch(searchTextController.text);
// 3
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            const SizedBox(
              width: 6.0,
            ),
            // *** Start Replace
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (!previousSearches.contains(value)) {
                        previousSearches.add(value);
                        savePreviousSearches();
                      }
                    },
                    controller: searchTextController,
                  )),
                  PopupMenuButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: lightGrey,
                      ),
                      onSelected: (String value) {
                        searchTextController.text = value;
                        startSearch(searchTextController.text);
                      },
                      itemBuilder: (context) {
                        return previousSearches
                            .map<CustomDropdownMenuItem<String>>((value) {
                          return CustomDropdownMenuItem<String>(
                            value: value,
                            text: value,
                            callback: () {
                              setState(() {
                                previousSearches.remove(value);
                                Navigator.pop(context);
                              });
                            },
                          );
                        }).toList();
                      }),
                ],
              ),
            ),
            // *** End Replace
          ],
        ),
      ),
    );
  }

  void startSearch(String value) {
    // 1
    setState(() {
// 2
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      value = value.trim();
// 3
      if (!previousSearches.contains(value)) {
        // 4
        previousSearches.add(value);
// 5
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
// 1
    if (searchTextController.text.length < 3) {
      return Container();
    }
// 2
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
      // 3
      future: RecipeService.create().queryRecipes(
          searchTextController.text.trim(),
          currentStartPosition,
          currentEndPosition),
// 4
      builder: (context, snapshot) {
// 5
        if (snapshot.connectionState == ConnectionState.done) {
          // 6
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  textAlign: TextAlign.center, textScaleFactor: 1.3),
            );
          }
// 7
          loading = false;
          final result = snapshot.data?.body;
// 2
          if (result is Error) {
            // Hit an error
            inErrorState = true;
            return _buildRecipeList(context, currentSearchList);
          }
// 3
          final query = (result as Success).value;
          inErrorState = false;
          if (query != null) {
            currentCount = query.count;
            hasMore = query.more;
            currentSearchList.addAll(query.hits);
            // 8
            if (query.to < currentEndPosition) {
              currentEndPosition = query.to;
            }
          }
// 9
          return _buildRecipeList(context, currentSearchList);
        } else {
          // 11
          if (currentCount == 0) {
            // Show a loading indicator while waiting for the recipes
            return const Center(child: CircularProgressIndicator());
          } else {
            // 12
            return _buildRecipeList(context, currentSearchList);
          }
        }
      },
    );
  }

  Widget _buildRecipeCard(
      BuildContext topLevelContext, List<APIHits> hits, int index) {
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {
        Navigator.push(topLevelContext, MaterialPageRoute(
          builder: (context) {
            return const RecipeDetails();
          },
        ));
      },
      child: recipeCard(recipe),
    );
  }

  Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
// 2
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;
    // 3
    return Flexible(
      // 4
      child: GridView.builder(
// 5
        controller: _scrollController,
// 6
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
// 7
        itemCount: hits.length,
// 8
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeCard(recipeListContext, hits, index);
        },
      ),
    );
  }
}
