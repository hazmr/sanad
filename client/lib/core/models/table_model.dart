class TableModel {
  final int id;
  final String name;
  final List<CheckTaskModel> checkTasks;
  final List<QuestionTaskModel> questionTasks;
  final DateTime? updatedAt;

  TableModel({
    required this.id,
    required this.name,
    required this.checkTasks,
    required this.questionTasks,
    this.updatedAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      checkTasks: (json['checkTasks'] as List<dynamic>?)
              ?.map((e) => CheckTaskModel.fromJson(e))
              .toList() ??
          [],
      questionTasks: (json['questionTasks'] as List<dynamic>?)
              ?.map((e) => QuestionTaskModel.fromJson(e))
              .toList() ??
          [],
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  int get totalTasks => checkTasks.where((t) => t.isActive).length + 
                        questionTasks.where((t) => t.isActive).length;
  
  int get completedTasks => 
      checkTasks.where((t) => t.isActive && t.value).length +
      questionTasks.where((t) => t.isActive && t.answer != null && t.answer!.isNotEmpty).length;

  double get progress => totalTasks > 0 ? completedTasks / totalTasks : 0;
}

class CheckTaskModel {
  final int id;
  final String taskId;
  final String label;
  final bool value;
  final bool isActive;

  CheckTaskModel({
    required this.id,
    required this.taskId,
    required this.label,
    required this.value,
    required this.isActive,
  });

  factory CheckTaskModel.fromJson(Map<String, dynamic> json) {
    return CheckTaskModel(
      id: json['id'],
      taskId: json['taskId'] ?? '',
      label: json['label'],
      value: json['value'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  CheckTaskModel copyWith({bool? value}) {
    return CheckTaskModel(
      id: id,
      taskId: taskId,
      label: label,
      value: value ?? this.value,
      isActive: isActive,
    );
  }
}

class QuestionTaskModel {
  final int id;
  final String taskId;
  final String label;
  final String? answer;
  final bool isActive;

  QuestionTaskModel({
    required this.id,
    required this.taskId,
    required this.label,
    this.answer,
    required this.isActive,
  });

  factory QuestionTaskModel.fromJson(Map<String, dynamic> json) {
    return QuestionTaskModel(
      id: json['id'],
      taskId: json['taskId'] ?? '',
      label: json['label'],
      answer: json['answer'],
      isActive: json['isActive'] ?? true,
    );
  }

  QuestionTaskModel copyWith({String? answer}) {
    return QuestionTaskModel(
      id: id,
      taskId: taskId,
      label: label,
      answer: answer ?? this.answer,
      isActive: isActive,
    );
  }
}
