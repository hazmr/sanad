import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class TokenInterceptorClient extends http.BaseClient {
  final http.Client _innerClient;
  final AuthProvider authProvider;

  TokenInterceptorClient({
    required this.authProvider,
    http.Client? innerClient,
  }) : _innerClient = innerClient ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Add authorization header if we have an access token
    if (authProvider.accessToken != null) {
      request.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';
    }

    // Send the request
    var response = await _innerClient.send(request);

    // If we get a 401 Unauthorized response, try to refresh the token
    if (response.statusCode == 401) {
      // Try to refresh the token
      final refreshed = await authProvider.refreshAccessToken();

      if (refreshed && authProvider.accessToken != null) {
        // Retry the original request with the new token
        var retryRequest = _copyRequest(request);
        retryRequest.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';
        response = await _innerClient.send(retryRequest);
      }
    }

    return response;
  }

  /// Create a copy of the request with a new body stream
  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest requestCopy;

    if (request is http.Request) {
      requestCopy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      requestCopy = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('Cannot retry a StreamedRequest');
    } else {
      throw Exception('Cannot copy request: $request');
    }

    requestCopy.headers.addAll(request.headers);

    return requestCopy;
  }
}
