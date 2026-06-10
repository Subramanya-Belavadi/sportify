import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  void setUserId(String userId) {
    _dio.options.headers['X-User-Id'] = userId;
  }

  String? get currentUserId => _dio.options.headers['X-User-Id'] as String?;

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw _map(e);
    } catch (_) {
      throw const NetworkException();
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _map(e);
    } catch (_) {
      throw const NetworkException();
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await post('/auth/login', data: {'email': email, 'password': password});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final res = await post('/auth/signup', data: {'name': name, 'email': email, 'password': password});
    return res.data as Map<String, dynamic>;
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _map(e);
    } catch (_) {
      throw const NetworkException();
    }
  }

  Exception _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException();
      default:
        final code = e.response?.statusCode;
        if (code == 409) return const SlotAlreadyTakenException();
        return ServerException(
          message: e.response?.data?['detail'] ?? e.message ?? 'Server error',
          statusCode: code,
        );
    }
  }
}
