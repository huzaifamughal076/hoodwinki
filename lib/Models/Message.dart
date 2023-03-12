class Message {
  Message({
    required this.message,
    required this.time,
    required this.senderId,
    required this.receiverId,
    required this.username,
    required this.read,
  });
  late final String message;
  late final time;
  late final String senderId;
  late final String receiverId;
  late final String username;
  late final String read;
  Message.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    senderId = json['senderId'].toString();
    message = json['message'].toString();
    receiverId = json['receiverId'].toString();
    username = json['username'].toString();
    read = json['read'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    data['senderId'] = senderId;
    data['message'] = message;
    data['receiverId'] = receiverId;
    data['username'] = username;
    data['read']=read;
    return data;
  }
}