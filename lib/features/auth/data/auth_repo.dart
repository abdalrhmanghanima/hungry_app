import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/core/utils/pref_helper.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  bool isGuest = false;
  UserModel? _currentUser;

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
        if (code != 200 && code != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(data);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
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

  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final response = await apiService.post('register', {
        'name': name,
        'email': email,
        'password': password,
      });
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final coder = int.tryParse(code);
        final data = response['data'];
        if (code != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(data);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
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

  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelper.getToken();
      if (token == null || token == 'guest') {
        return null;
      }
      final response = await apiService.get('profile');
      final user = UserModel.fromJson(response['data']);
      _currentUser = user;
      return user;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> updateProfileData({
    required String name,
    required String email,
    required String address,
    String? visa,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'address': address,
        if (visa != null && visa.isNotEmpty) 'Visa': visa,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: 'profile.jpg',
          ),
      });

      final response = await apiService.post('update-profile', formData);

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];
        final coder = int.tryParse(code.toString());

        if (coder != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final updateUser = UserModel.fromJson(data);
        _currentUser = updateUser;
        return updateUser;
      } else {
        throw ApiError(message: 'Invalid Error');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> logOut() async {
    final response = await apiService.post('logout', {});
    if (response['data'] != null) {
      throw ApiError(message: 'Error');
    }
    await PrefHelper.removeToken();
    _currentUser = null;
    isGuest = false;
  }

  Future<UserModel?> autoLogin() async {
    final token = await PrefHelper.getToken();

    // 🟢 Guest
    if (token == null || token == 'guest') {
      isGuest = true;
      _currentUser = null;
      return null;
    }

    // 🔵 Logged in
    try {
      final user = await getProfileData();
      _currentUser = user;
      isGuest = false;
      return user;
    } catch (_) {
      await PrefHelper.removeToken();
      isGuest = true;
      _currentUser = null;
      return null;
    }
  }

  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelper.saveToken('guest');
  }

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => !isGuest && _currentUser != null;
}
