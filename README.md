# ✅ CheckMe Todo App

A sleek, modern to-do list application built with Flutter that helps users manage their tasks efficiently with categorization, search functionality, and detailed task tracking.

![CheckMe App](https://github.com/yourusername/checkme-todo/raw/main/screenshots/app_preview.png)

## ✨ Features

- **🔐 User Authentication**: Simple login interface for user access
- **📝 Task Management**: Create, view, edit, and delete tasks
- **🏷️ Categorization**: Organize tasks into categories (School, Personal, Work, Urgent, General)
- **🔍 Search Functionality**: Search through tasks by title or description
- **📅 Due Date Tracking**: Set and track task deadlines with overdue notifications
- **✓ Task Status**: Mark tasks as complete/incomplete with visual indicators
- **🔎 Task Details**: View comprehensive task information on a dedicated screen

## 🛠️ Tech Stack

- **📱 Flutter**: UI framework for cross-platform development
- **⚙️ Riverpod**: State management solution

## 📁 Project Structure

### Core Files

#### `todo.dart`

This file defines the `Todo` data model which is the foundation of the application:

```dart
import 'package:flutter/foundation.dart';
class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final String category;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.category = 'General',
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}
```

Key aspects:
- 🔒 Uses immutable design pattern with final fields
- 🔄 Implements `copyWith()` method for creating modified copies without changing the original
- 🔘 Supports optional fields like description and dueDate
- 🏷️ Includes category classification for better organization

#### `login_screen.dart`

The login screen serves as the entry point to the application:

```dart
class LoginScreen extends StatefulWidget {
  // Login screen implementation
}
```

Key features:
- 🌈 Gradient background with modern UI design
- ✅ Form validation for email and password fields
- 🚀 Navigation to the home screen upon successful login
- 🔑 "Forgot Password" functionality placeholder

Implementation details:
- 📝 Uses `TextFormField` with validation for form inputs
- 📋 Implements a `Form` widget with `GlobalKey<FormState>` for validation control
- 🎨 Custom styling with rounded corners and appropriate icons

#### `home_screen.dart`

The main dashboard where users manage their todos:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';
import 'todo_provider.dart';
import 'todo_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
```

Key features:
- 🔍 Task filtering by category and search text
- 📋 Task list with completion status indicators
- ➕ Add new tasks through a modal bottom sheet
- 🗑️ Delete tasks with long press
- 📱 Navigate to task details screen

Implementation details:
- 🔄 Uses Riverpod for state management with `ConsumerStatefulWidget`
- 🔍 Implements search functionality with real-time filtering
- 🏷️ Category dropdown for filtering tasks
- 📝 Task entry form with date picker for due dates
- 🚦 Visual indicators for task status (completed, pending, overdue)

Key features:
- 🔄 Uses `ConsumerWidget` from Riverpod to access the state
- 🔎 Displays detailed information about a specific todo
- ✏️ Enables editing of todo title, description, and due date
- 💾 Provides a save button to update the todo through the provider
- 📆 Shows creation date for reference
- 📅 Implements a date picker for modifying due dates

### 🧠 State Management

#### `todo_provider.dart`

The app uses `flutter_riverpod` for state management, with a dedicated provider for todos:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);  // Initialize with empty todo list

  void addTodo(Todo todo) {
    state = [...state, todo];  // Create new list with added todo
  }

  void toggleComplete(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);  // Toggle completion status
      }
      return todo;
    }).toList();
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();  // Filter out deleted todo
  }

  void updateTodo(Todo updatedTodo) {
    state = state.map((todo) {
      if (todo.id == updatedTodo.id) {
        return updatedTodo;  // Replace with updated version
      }
      return todo;
    }).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
```

Key aspects:
- 🧠 Uses `StateNotifier` from Riverpod for immutable state management
- 🔄 Implements pure functions that return new state objects rather than modifying existing ones
- 🛠️ Provides CRUD operations for todos:
  - ➕ `addTodo`: Adds a new todo to the list
  - ✅ `toggleComplete`: Toggles the completion status of a todo
  - 🗑️ `deleteTodo`: Removes a todo from the list
  - 🔄 `updateTodo`: Updates an existing todo with new values
- 🌐 The `todoProvider` is exposed as a global access point that components can use to read or modify the todo list

## 📥 App Architecture and Workflow

The CheckMe Todo app follows a clean architecture pattern with clear separation of concerns:

1. **📊 Data Layer**: Represented by the `Todo` model class which defines the structure of the data.

2. **🧠 State Management Layer**: Handled by `TodoNotifier` and Riverpod providers, which manage the state of the application and provide methods to modify it.

3. **🎨 UI Layer**: Consists of screens and widgets that display the data and interact with the user.

### 👤 User Flow

1. User logs in through the `LoginScreen`
2. Upon successful login, they are directed to the `HomeScreen` where they can:
   - 👀 View their list of todos
   - 🔍 Filter todos by category or search text
   - ➕ Add new todos via the floating action button
   - ✅ Mark todos as complete/incomplete

## 🚀 Installation

1. Make sure you have Flutter installed on your machine
2. Clone the repository:
   ```
   git clone https://github.com/yourusername/checkme-todo.git
   ```
3. Navigate to the project directory:
   ```
   cd checkme-todo
   ```
4. Install dependencies:
   ```
   flutter pub get
   ```
5. Run the app:
   ```
   flutter run
   ```

## 📱 Usage

1. 🚀 Launch the app and log in with your credentials
2. ➕ Use the "+" button to add new tasks
3. 🏷️ Categorize tasks and set due dates as needed
4. 🔍 Filter tasks by category or search for specific tasks
5. ✅ Mark tasks as complete by tapping the checkbox
6. 🔎 View task details by tapping on a task
7. 🗑️ Delete tasks by long-pressing on them

## 🔮 Future Enhancements

- ☁️ Cloud synchronization for tasks
- 👤 User registration and profile management
- 👥 Task sharing and collaboration
- 🔄 Recurring tasks and reminders
- 🌙 Dark mode support
- 🏷️ Custom categories

## Screensots

![image](https://github.com/user-attachments/assets/0f4b800b-91ab-40da-8c76-26d573612a1d)

in the above screenshot it tried to login with email which does not contains "@" so it fails to login due to some validations

![image](https://github.com/user-attachments/assets/b7570346-da5a-4a79-8531-7752f1a0ec56)

then here login is working

![image](https://github.com/user-attachments/assets/a3e56dca-2643-4e86-8b79-41c49f139e80)

this is home screen where i can add my tasks, view them, delete them and search them.

![image](https://github.com/user-attachments/assets/2ddc16be-f776-4c65-958d-535e8cabd77a)

in te above screenshot it shows the todo details screen after clinking on the "+" button to allow you to add a task with it's descrption and it's due date as well

![image](https://github.com/user-attachments/assets/39221479-203b-45ae-82c2-16372554ae57)

the above screenshot shows that app allows you to add the due date to you tasks

![image](https://github.com/user-attachments/assets/fdcddafc-6297-458b-94d2-a3806c03b720)

here this screenshot shows the general activities

![image](https://github.com/user-attachments/assets/d7c604d3-f1a0-4b11-809c-a2dde8b60645)

in the above screenshot it shows that after clicking on save button the tacks is added to the todo list with the task's title, status, description and due date; and here the status is pending because it is unchecked.

![image](https://github.com/user-attachments/assets/12e06237-d44a-4838-b524-0c7daedea788)

for example in above screenshot it shows that the task is checked so the status automatically changed from pending to done.

![image](https://github.com/user-attachments/assets/878201f6-7cdc-4712-8130-948944de13a4)

on the above screenshot i have created many tasks and i have putted their descriptions and their due dates as well, and their status some are done and other are still pending.

![image](https://github.com/user-attachments/assets/d29bd0f4-4df7-4a5d-aad2-e4b4f4d21eab)

as you are seeing here on this screenshot also i have the opportunity to edit my task when i have already created it but forexample if i want to change something.

![image](https://github.com/user-attachments/assets/d89bc7d1-248f-4e4c-8b96-956ff58366ab)

as you are seeing here in this screenshot i have the opportunity to search my task.














## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. 🍴 Fork the repository
2. 🌿 Create your feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Commit your changes (`git commit -m 'Add some amazing feature'`)
4. 📤 Push to the branch (`git push origin feature/amazing-feature`)
5. 🔍 Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

Your Name - [Titus Mucyo](https://twitter.com/yourusername) - titusmucyo693@gmail.com

Project Link: [https://github.com/Titus-30/checkMe-Todo-App..git](https://github.com/Titus-30/checkMe-Todo-App..git)

## 🆕 Getting Started

A few resources to get you started if this is your first Flutter project:

- 📚 [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- 📖 [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
