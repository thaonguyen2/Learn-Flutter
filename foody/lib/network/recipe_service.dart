import 'package:chopper/chopper.dart';
import 'recipe_model.dart';
import 'model_response.dart';
import 'model_converter.dart';

part 'recipe_service.chopper.dart';

const String apiKey = 'aac546e5bc41d569c0fc392408dd24f3';
const String apiId = '26c2cc2b';
const String apiUrl = 'https://api.edamam.com/';

@ChopperApi()
// 2
abstract class RecipeService extends ChopperService {
  @Get(path: 'search')
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      @Query('q') String query, @Query('from') int from, @Query('to') int to);

  static RecipeService create() {
    // 1
    final client = ChopperClient(
      // 2
      baseUrl: apiUrl,
// 3
      interceptors: [_addQuery, HttpLoggingInterceptor()],
// 4
      converter: ModelConverter(),
// 5
      errorConverter: const JsonConverter(),
      // 6
      services: [
        _$RecipeService(),
      ],
    );
// 7
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
// 1
  final params = Map<String, dynamic>.from(req.parameters);
  // 2
  params['app_id'] = apiId;
  params['app_key'] = apiKey;
  return req.copyWith(parameters: params);
}

/*
import 'package:http/http.dart';
class RecipeService {
  // 1
  Future getData(String url) async {
    // 2
    print('Calling url: $url');
    // 3
    final response = await get(Uri.parse(url));
    // 4
    if (response.statusCode == 200) {
// 5
      return response.body;
    } else {
// 6
      print(response.statusCode);
    }
  }

  Future<dynamic> getRecipes(String query, int from, int to) async {
// 2
    final recipeData = await getData(
        '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    // 3
    return recipeData;
  }
} */
