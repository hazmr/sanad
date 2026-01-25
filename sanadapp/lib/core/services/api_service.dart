import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/table_model.dart';
import '../models/patient_model.dart';
import '../models/history_model.dart';
import '../providers/auth_provider.dart';
import 'token_interceptor_client.dart';

class ApiService {
  static const String baseUrl = 'https://sanad.tryasp.net/api';
  
  late http.Client _httpClient;
  
  ApiService({AuthProvider? authProvider}) {
    if (authProvider != null) {
      _httpClient = TokenInterceptorClient(authProvider: authProvider);
    } else {
      _httpClient = http.Client();
    }
  }
  
  void setAccessToken(String token) {
    // Token is now managed by AuthProvider through the interceptor
  }
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };
  
  // Auth
  Future<Map<String, dynamic>?> login(String phoneNumber, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  Future<Map<String, dynamic>?> refreshToken(String accessToken, String refreshToken) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/Auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': accessToken,
          'refreshToken': refreshToken,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
  
  // Patient endpoints
  Future<Map<String, dynamic>?> getPatientProfile() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Patient/profile'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }
  
  Future<TableModel?> getPatientTable() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Patient/table'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return TableModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get table: $e');
    }
  }
  
  Future<bool> updateCheckTask(int checkId, bool value) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/Patient/table/checks/$checkId'),
        headers: _headers,
        body: jsonEncode({'value': value}),
      );
      
      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to update check task: $e');
    }
  }
  
  Future<bool> updateQuestionTask(int questionId, String? answer) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/Patient/table/questions/$questionId'),
        headers: _headers,
        body: jsonEncode({'answer': answer}),
      );
      
      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to update question task: $e');
    }
  }
  
  Future<List<TaskHistoryModel>> getPatientHistory() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Patient/history'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => TaskHistoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }
  
  // Doctor endpoints
  Future<List<PatientModel>> getDoctorPatients() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Doctor/patients'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => PatientModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get patients: $e');
    }
  }

  // Search patients by name or phone number
  Future<List<PatientModel>> searchPatients(String query) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Doctor/patients/search?q=${Uri.encodeComponent(query)}'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => PatientModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search patients: $e');
    }
  }
  
  Future<Map<String, dynamic>?> registerPatient(
      String name, String phoneNumber, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/Doctor/register-patient'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );
      
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to register patient: $e');
    }
  }
  
  Future<TableModel?> getPatientTableByDoctor(int patientId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Doctor/patients/$patientId/table'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return TableModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get patient table: $e');
    }
  }
  
  Future<TableModel?> createPatientTable(
    int patientId, 
    String name,
    List<String> checkTaskLabels,
    List<String> questionTaskLabels,
  ) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/Doctor/patients/$patientId/table'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'checkTasks': checkTaskLabels.map((l) => {'label': l}).toList(),
          'questionTasks': questionTaskLabels.map((l) => {'label': l}).toList(),
        }),
      );
      
      if (response.statusCode == 201) {
        return TableModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create table: $e');
    }
  }
  
  Future<TableModel?> updatePatientTable(
    int patientId,
    String name,
    List<Map<String, dynamic>> checkTasks,
    List<Map<String, dynamic>> questionTasks,
  ) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/Doctor/patients/$patientId/table'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'checkTasks': checkTasks,
          'questionTasks': questionTasks,
        }),
      );
      
      if (response.statusCode == 200) {
        return TableModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update table: $e');
    }
  }
  
  Future<List<TaskHistoryModel>> getPatientHistoryByDoctor(int patientId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Doctor/patients/$patientId/history'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => TaskHistoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get patient history: $e');
    }
  }

  // Get patient details
  Future<Map<String, dynamic>?> getPatientDetails(int patientId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/Doctor/patients/$patientId'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get patient details: $e');
    }
  }

  // Update patient details
  Future<Map<String, dynamic>?> updatePatient(
    int patientId,
    String name,
    String? phoneNumber,
    String? newPassword,
  ) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/Doctor/patients/$patientId'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'phoneNumber': phoneNumber,
          'newPassword': newPassword,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  // Delete patient
  Future<bool> deletePatient(int patientId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/Doctor/patients/$patientId'),
        headers: _headers,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }
}
