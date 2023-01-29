class Message {
  Message({
    required this.message,
    required this.time,
    required this.senderId,
    required this.receiverId,
    required this.username,
  });
  late final String message;
  late final String time;
  late final String senderId;
  late final String receiverId;
  late final String username;
  Message.fromJson(Map<String, dynamic> json) {
    time = json['time'].toString();
    senderId = json['senderId'].toString();
    message = json['message'].toString();
    receiverId = json['receiverId'].toString();
    username = json['username'].toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    data['senderId'] = senderId;
    data['message'] = message;
    data['receiverId'] = receiverId;
    data['username'] = username;
    return data;
  }
}