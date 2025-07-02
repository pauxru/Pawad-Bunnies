class Todo {
  final Map<String, dynamic> sys;
  final String taskRef;
  final String taskType;
  final String matingIdRef;
  final String taskIntroDate;
  bool closed;
  final String taskCloseDate;
  final String taskMessage;
  dynamic answerData;
  final String taskID;

  Todo({
    required this.sys,
    required this.taskRef,
    required this.taskType,
    required this.matingIdRef,
    required this.taskIntroDate,
    required this.closed,
    required this.taskCloseDate,
    required this.taskMessage,
    required this.answerData,
    required this.taskID,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      sys: json['sys'] ?? '',
      taskRef: json['taskRef'] ?? '',
      taskType: json['taskType'] ?? '',
      matingIdRef: json['matingIdRef'] ?? '',
      taskIntroDate: json['taskIntroDate'] ?? '',
      closed: json['closed'] ?? false,
      taskCloseDate: json['taskCloseDate'] ?? '',
      taskMessage: json['taskMessage'] ?? '',
      answerData: json['answerData'] ?? '',
      taskID: json['taskID'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sys': sys,
      'taskRef': taskRef,
      'taskType': taskType,
      'matingIdRef': matingIdRef,
      'taskIntroDate': taskIntroDate,
      'closed': closed,
      'taskCloseDate': taskCloseDate,
      'taskMessage': taskMessage,
      'answerData': answerData,
      'taskID': taskID,
    };
  }
}