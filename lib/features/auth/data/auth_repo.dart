import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/core/utils/pref_helper.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post('login', {
        'email': email,
        'password': password,
      });
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];
        if (code != 200 &&code!=201) {
          throw ApiError(message: msg??"Unknown Error");
        }
        final user = UserModel.fromJson(data);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        return user;
      } else {
        throw ApiError(message: 'UnExpected Error From Server');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?>signup(String name,String email, String password)async{

    try {

      final response = await apiService.post('register', {
        'name':name,
        'email': email,
        'password': password,
      });
      if(response is ApiError){
        throw response;
      }if(response is Map<String,dynamic>){
        final msg = response['message'];
        final code = response['code'];
        final coder = int.tryParse(code);
        final data = response['data'];
        if (code != 200 &&coder!=201) {
          throw ApiError(message: msg??"Unknown Error");
        }
        final user = UserModel.fromJson(data);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        return user;
      } else {
        throw ApiError(message: 'UnExpected Error From Server');
      }

    }on DioException catch(e){
      throw ApiExceptions.handleError(e);
    }catch (e){
      throw ApiError(message: e.toString());
    }
  }
}
