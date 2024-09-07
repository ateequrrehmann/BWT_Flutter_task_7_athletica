class MessageModel {
  final String sendBy;
  final String receiveBy;
  final String message;
  final String type;
  final dynamic time;
  final String docName;
  final String? status;

  const MessageModel({
    required this.sendBy,
    required this.receiveBy,
    required this.message,
    required this.type,
    required this.time,
    required this.docName,
    this.status,
  });

  MessageModel copyWith({
    String? sendBy,
    String? receiveBy,
    String? message,
    String? type,
    dynamic time,
    String? docName,
    String? status,
  }) {
    return MessageModel(
      sendBy: sendBy ?? this.sendBy,
      receiveBy: receiveBy ?? this.receiveBy,
      message: message ?? this.message,
      type: type ?? this.type,
      time: time ?? this.time,
      docName: docName ?? this.docName,
      status: status ?? this.status,
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      sendBy: data['sendBy'] ?? '',
      receiveBy: data['receiveBy'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? '',
      time: data['time'],
      docName: data['docName'] ?? '',
      status: data['status'],
    );
  }


}
