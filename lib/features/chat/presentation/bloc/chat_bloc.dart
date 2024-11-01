import 'package:bloc/bloc.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/create_chat_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/fetch_message_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/listen_to_message_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/listen_to_user_presence_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/send_message_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/set_user_presence_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domian/entities/chat_entity.dart';
import '../../domian/entities/message_entity.dart';
import '../../domian/usecases/get_all_chats_usecase.dart';
import '../../domian/usecases/update_message_read_status_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetAllChats getAllChats;
  final FetchMessages fetchMessages;
  final ListenToMessages listenToMessages;
  final SetUserPresence setUserPresence;
  final ListenToUserPresence listenToUserPresence;
  final UpdateMessageReadStatus updateMessageReadStatus;
  final CreateChatUsecase createChatUsecase;
  ChatBloc(
    this.sendMessage,
    this.getAllChats,
    this.fetchMessages,
    this.listenToMessages,
    this.setUserPresence,
    this.listenToUserPresence,
    this.updateMessageReadStatus,
    this.createChatUsecase,
  ) : super(ChatInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      final result = await getAllChats(event.userId, event.isGroup);
      result.fold(
        (failure) {
          emit(const ChatError("Failed to load chats"));
        },
        (chats) => emit(ChatLoaded(chats)),
      );
    });

    on<CreateChat>((event, emit) async {
      emit(ChatLoading());
      final result = await createChatUsecase(event.chat);
      result.fold(
        (failure) => emit(const ChatError("Failed to create chat")),
        (chat) => emit(ChatCreated(chat)),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      final result = await sendMessage(event.message);
      result.fold(
        (failure) => emit(ChatError(_mapFailureToMessage(failure))),
        (_) => add(FetchMessagesEvent(event.chatId)),
      );
    });

    on<FetchMessagesEvent>((event, emit) async {
      emit(MessageLoading());
      final result = await fetchMessages(event.chatId);
      result.fold(
        (failure) {
          emit(ChatError(_mapFailureToMessage(failure)));
        },
        (messages) {
          emit(MessageLoaded(messages));
        },
      );
    });

    on<ListenToMessagesEvent>((event, emit) async {
      final result = await listenToMessages(event.chatId);
      result.fold(
        (failure) => emit(ChatError(_mapFailureToMessage(failure))),
        (messageStream) => emit(ChatListening(messageStream)),
      );
    });

    on<SetUserPresenceEvent>((event, emit) async {
      final result = await setUserPresence(event.userId, event.isOnline);
      result.fold(
        (failure) => emit(ChatError(_mapFailureToMessage(failure))),
        (_) => null,
      );
    });

    on<ListenToUserPresenceEvent>((event, emit) async {
      final result = await listenToUserPresence(event.userId);
      result.fold(
        (failure) => emit(ChatError(_mapFailureToMessage(failure))),
        (presenceStream) async {
          await for (final isOnline in presenceStream) {
            emit(UserPresenceUpdated({event.userId: isOnline}));
          }
        },
      );
    });

    on<UpdateMessageReadStatusEvent>((event, emit) async {
      final result =
          await updateMessageReadStatus(event.messageId, event.isRead);
      result.fold(
        (failure) => emit(ChatError(_mapFailureToMessage(failure))),
        (_) => emit(MessageReadStatusUpdated()),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred. Please try again.';
  }
}
