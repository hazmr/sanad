class TaskHistoryModel {
  final int id;
  final DateTime date;
  final DateTime savedAt;
  final List<HistoryCheckTaskModel> checkTasks;
  final List<HistoryQuestionTaskModel> questionTasks;

  TaskHistoryModel({
    required this.id,
    required this.date,
    required this.savedAt,
    required this.checkTasks,
    required this.questionTasks,
  });

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) {
    return TaskHistoryModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      savedAt: DateTime.parse(json['savedAt']),
      checkTasks: (json['checkTasks'] as List<dynamic>?)
              ?.map((e) => HistoryCheckTaskModel.fromJson(e))
              .toList() ??
          [],
      questionTasks: (json['questionTasks'] as List<dynamic>?)
              ?.map((e) => HistoryQuestionTaskModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  int get totalTasks => checkTasks.length + questionTasks.length;
  int get completedCheckTasks => checkTasks.where((t) => t.value).length;
  int get answeredQuestions => questionTasks.where((t) => t.answer != null && t.answer!.isNotEmpty).length;
}

class HistoryCheckTaskModel {
  final int id;
  final String label;
  final bool value;

  HistoryCheckTaskModel({
    required this.id,
    required this.label,
    required this.value,
  });

  factory HistoryCheckTaskModel.fromJson(Map<String, dynamic> json) {
    return HistoryCheckTaskModel(
      id: json['id'],
      label: json['label'],
      value: json['value'] ?? false,
    );
  }
}

class HistoryQuestionTaskModel {
  final int id;
  final String label;
  final String? answer;

  HistoryQuestionTaskModel({
    required this.id,
    required this.label,
    this.answer,
  });

  factory HistoryQuestionTaskModel.fromJson(Map<String, dynamic> json) {
    return HistoryQuestionTaskModel(
      id: json['id'],
      label: json['label'],
      answer: json['answer'],
    );
  }
}
