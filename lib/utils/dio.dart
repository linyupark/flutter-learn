import 'package:dio/dio.dart';

// class MyTransformer extends DefaultTransformer {
//   @override

// }

Dio dio = Dio(
  BaseOptions(
    baseUrl: 'http://192.168.0.105/fastpay-app-api-unencode/',
    connectTimeout: 20000,
    receiveTimeout: 20000,
  ),
)..interceptors.add(
    InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      // options.data = options.data.toJson();

      // print(options.method);
      // print(options.sendTimeout);
      // print(options.receiveTimeout);
      // print(options.connectTimeout);

      // print(options.path);
      // print(options.baseUrl);
      // print(options.data);
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) async {
      int statusCode = response.statusCode;
      dynamic data = response.data;

      // print('--- response start ---');
      // print(data.code);
      // print('--- response end ---');
      // print(data);
      if (statusCode == 200) {
        if (data['code'] == 200) {
          // dio.resolve(data.data);
          return data;
        }
        dio.reject('Response Error');
      } else {
        dio.reject('Service Error');
      }
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) async {
      print('Unknown exception: $e');
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
      // Do something with response error
      return e; //continue
    }),
  );
// ..interceptors.add(LogInterceptor(responseBody: true));
