
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

final usersRef = firestore.collection('Users');
final watchesRef = firestore.collection('Watches');
final chatsRef = firestore.collection('Chats');