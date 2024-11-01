# collaborative_todo_app_with_chat_functionality

## OverView

A mobile application built using Flutter that combines task management with a real-time chat feature. Users can manage tasks, collaborate on todos, and communicate with each other in real-time through private and group chats.

## Project Description

This app allows users to manage tasks and communicate in real-time, combining productivity and collaboration tools. Users can create todos, set reminders, collaborate on tasks, and engage in private or group chats. The chat functionality supports real-time messaging, user presence indicators, and multimedia sharing.

## Features

### Todo Features

**Create, Update, and Delete Todos**: Manage todos with the ability to set descriptions, due dates, reminders, and color codes.
**Collaborate on Todos**: Invite collaborators by email. Collaborators can edit todos but cannot delete them.
**Pin Todos**: Pin important todos at the top.
**Task Notification**: Receive notifications reminders.

### Chat Features

**Real-time Messaging**: Chat with other users in real-time using Firebase.
**Private and Group Chats:**: Engage in both one-on-one and group conversations.
**User Presence**: See online status indicators for active users in chat.
**Media Sharing**: Send images, text, and audio messages in chats.
**Message Search:**: Quickly find messages using a keyword search in both private and group chats.

## Teck Stack

**Flutter**: For building the cross-platform mobile application.
**Firebase**: Real-time database for chat, Firestore for data storage, Firebase Auth for user authentication, and Firebase Cloud Messaging for notifications.
**Dartz Package**: For functional programming and error handling.
**BLoC State Management**: Used BLoC for managing state with clean architecture.

## Architecture

The project follows a clean architecture approach with three main layers:

**Data Layer**: Manages data sources (Firebase) and implements repositories.
**Domain Layer**: Contains core business logic and use cases.
**Presentation Layer**: UI components and BLoC for state management.
