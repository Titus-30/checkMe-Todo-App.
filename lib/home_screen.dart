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

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final filteredTodos = todos.where((todo) {
      final queryMatch = searchQuery.isEmpty ||
          todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      final categoryMatch = selectedCategory == 'All' || todo.category == selectedCategory;
      return queryMatch && categoryMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CheckMe - Todo Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              child: Text(widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search Todos',
                    hintText: 'Search by title or description',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: ['All', 'School', 'Personal', 'Urgent', 'Work', 'General']
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.userName} 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Your Todos', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: filteredTodos.isEmpty
                  ? const Center(child: Text('No todos found. Try a different search.'))
                  : ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailsScreen(todo: todo),
                        ),
                      );
                    },
                    onLongPress: () {
                      ref.read(todoProvider.notifier).deleteTodo(todo.id);
                    },
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) {
                        ref.read(todoProvider.notifier).toggleComplete(todo.id);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.category),
                        const SizedBox(height: 4),
                        Text(
                          todo.isCompleted ? 'Done' : 'Pending',
                          style: TextStyle(
                            color: todo.isCompleted ? Colors.green : Colors.red,
                          ),
                        ),
                        if (todo.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Due: ${todo.dueDate!.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (todo.dueDate!.isBefore(DateTime.now()))
                            const Text(
                              'Overdue',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDueDate;
    String selectedCategory = 'General';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New Todo', style: TextStyle(fontSize: 20)),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDueDate == null
                          ? 'No Due Date Chosen'
                          : 'Due: ${selectedDueDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    child: const Text('Pick Due Date'),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDueDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: ['School', 'Personal', 'Urgent', 'Work', 'General']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final desc = descriptionController.text.trim();

                  if (title.isNotEmpty) {
                    final newTodo = Todo(
                      id: DateTime.now().toIso8601String(),
                      title: title,
                      description: desc.isNotEmpty ? desc : null,
                      createdAt: DateTime.now(),
                      dueDate: selectedDueDate,
                      category: selectedCategory,
                      isCompleted: false, // ✅ Fixed here
                    );
                    ref.read(todoProvider.notifier).addTodo(newTodo);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Todo'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
