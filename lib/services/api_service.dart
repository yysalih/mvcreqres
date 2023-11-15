import 'package:mvcreqres/constants.dart';

import '../controllers/auth_controller.dart';
import '../models/base_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final class ApiService {

  static Future<(List<T>, String?)> getDatas<T extends BaseModel>({
    required String url,
    required T model,
    required String key,
  }) async {
    final Dio dio = Dio();

    try {
      final Response response = await dio.get(url);
      var array = <T>[];

      if (response.statusCode == HttpStatus.ok) {
        Iterable listBest = response.data[key];
        array = listBest.map<T>((element) => model.fromJson(element)).toList();
        return (array, null);
      } else {
        String? errorMessage =
        response.data[ResponseKeys.error.name] as String?;
        return (array, errorMessage);
      }
    } on DioException catch (e) {
      var array = <T>[];

      if (e.response == null)
        return (array, Constants.errorSomethingWrong);

      String? errorMessage = e.response!.data[ResponseKeys.error.name] as String?;
      return (array, errorMessage);
    }
  }

  static Future<(T, String?)> postData<T extends BaseModel>({
    required String url,
    required T model,
    required Map<String, dynamic> body,
  }) async {
    final dio = Dio();

    try {
      final Response response = await dio.post(
        url,
        data: body,
      );

      if (response.statusCode == HttpStatus.ok) {
        model = model.fromJson(response.data);
        return (model, null);
      } else {
        String? errorMessage =
        response.data[ResponseKeys.error.name] as String?;
        return (model, errorMessage);
      }
    } on DioException catch (e) {
      if (e.response == null)

        return (model, Constants.errorSomethingWrong);

      String? errorMessage = e.response!.data[ResponseKeys.error.name] as String?;
      print(e);
      print(e.error);
      print(e.message);
      print(e.stackTrace);
      return (model, errorMessage);
    }
  }

}