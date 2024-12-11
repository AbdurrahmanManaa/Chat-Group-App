import 'package:chatapp/constants.dart';
import 'package:chatapp/cubits/chat_cubit/chat_state.dart';
import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  sendMessage({required String message, required String email}) {
    messages.add(
      {kMessage: message, kCreatedAt: DateTime.now(), 'id': email},
    );
  }

  getMessage() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
