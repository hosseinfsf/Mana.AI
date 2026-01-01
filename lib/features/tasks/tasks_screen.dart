import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> _tasks = [];
  List<ShoppingItem> _shoppingList = [];
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = context.read<StorageService>();
    
    final tasksData = storage.getTasks();
    final shoppingData = storage.getShoppingList();
    final notesData = storage.getNotes();
    
    setState(() {
      _tasks = tasksData.map((e) => Task.fromMap(e)).toList();
      _shoppingList = shoppingData.map((e) => ShoppingItem.fromMap(e)).toList();
      _notes = notesData.map((e) => Note.fromMap(e)).toList();
    });
  }

  Future<void> _saveTasks() async {
    final storage = context.read<StorageService>();
    await storage.saveTasks(_tasks.map((e) => e.toMap()).toList());
  }

  Future<void> _saveShoppingList() async {
    final storage = context.read<StorageService>();
    await storage.saveShoppingList(_shoppingList.map((e) => e.toMap()).toList());
  }

  Future<void> _saveNotes() async {
    final storage = context.read<StorageService>();
    await storage.saveNotes(_notes.map((e) => e.toMap()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مدیریت کارها',
                            style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                          ),
                          Text(
                            'کارها، خرید و یادداشت',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: -0.3, end: 0),
              
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: Colors.white60,
                indicatorColor: theme.colorScheme.primary,
                tabs: const [
                  Tab(text: 'کارها ✅'),
                  Tab(text: 'خرید 🛒'),
                  Tab(text: 'یادداشت 📝'),
                ],
              ),
              
              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTasksTab(),
                    _buildShoppingTab(),
                    _buildNotesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        icon: const Icon(Icons.add_rounded),
        label: Text(_getAddButtonText()),
      ),
    );
  }

  String _getAddButtonText() {
    switch (_tabController.index) {
      case 0:
        return 'کار جدید';
      case 1:
        return 'آیتم جدید';
      case 2:
        return 'یادداشت جدید';
      default:
        return 'افزودن';
    }
  }

  Widget _buildTasksTab() {
    final completedTasks = _tasks.where((t) => t.isCompleted).length;
    
    return Column(
      children: [
        // Progress
        if (_tasks.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'پیشرفت امروز',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completedTasks / ${_tasks.length}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _tasks.isEmpty ? 0 : completedTasks / _tasks.length,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.3, end: 0),
        
        // Tasks list
        Expanded(
          child: _tasks.isEmpty
              ? _buildEmptyState('هنوز کاری نداری! 🎉\nیه کار جدید اضافه کن')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(_tasks[index], index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    final theme = Theme.of(context);
    final priorityInfo = AppConstants.taskPriorities[task.priority];
    
    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() => _tasks.removeAt(index));
        _saveTasks();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کار حذف شد')),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            setState(() {
              task.isCompleted = !task.isCompleted;
            });
            _saveTasks();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: task.isCompleted
                      ? Colors.green
                      : theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Colors.white60
                              : Colors.white,
                        ),
                      ),
                      if (task.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('yyyy/MM/dd').format(task.dueDate!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  priorityInfo['icon'],
                  color: priorityInfo['color'],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildShoppingTab() {
    return _shoppingList.isEmpty
        ? _buildEmptyState('لیست خریدت خالیه! 🛒\nچیزی اضافه کن')
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _shoppingList.length,
            itemBuilder: (context, index) {
              return _buildShoppingCard(_shoppingList[index], index);
            },
          );
  }

  Widget _buildShoppingCard(ShoppingItem item, int index) {
    return Dismissible(
      key: Key(item.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() => _shoppingList.removeAt(index));
        _saveShoppingList();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            setState(() {
              item.isPurchased = !item.isPurchased;
            });
            _saveShoppingList();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  item.isPurchased
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: item.isPurchased
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isPurchased
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.isPurchased
                          ? Colors.white60
                          : Colors.white,
                    ),
                  ),
                ),
                if (item.quantity != null)
                  Text(
                    '×${item.quantity}',
                    style: const TextStyle(color: Colors.white60),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildNotesTab() {
    return _notes.isEmpty
        ? _buildEmptyState('هنوز یادداشتی نداری! 📝\nیه یادداشت بنویس')
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return _buildNoteCard(_notes[index], index);
            },
          );
  }

  Widget _buildNoteCard(Note note, int index) {
    return Dismissible(
      key: Key(note.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() => _notes.removeAt(index));
        _saveNotes();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => _showEditNoteDialog(note),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.title.isNotEmpty)
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (note.title.isNotEmpty) const SizedBox(height: 8),
                Text(
                  note.content,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy/MM/dd HH:mm').format(note.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 80,
            color: Colors.white30,
          ).animate().fadeIn().scale(),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white60,
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  void _showAddDialog() {
    switch (_tabController.index) {
      case 0:
        _showAddTaskDialog();
        break;
      case 1:
        _showAddShoppingDialog();
        break;
      case 2:
        _showAddNoteDialog();
        break;
    }
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    int priority = 1;
    DateTime? dueDate;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('کار جدید'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان کار',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: priority,
                  decoration: const InputDecoration(
                    labelText: 'اولویت',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.taskPriorities.asMap().entries.map((e) {
                    return DropdownMenuItem(
                      value: e.key,
                      child: Row(
                        children: [
                          Icon(e.value['icon'], color: e.value['color'], size: 20),
                          const SizedBox(width: 8),
                          Text(e.value['name']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setDialogState(() => priority = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('لغو'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      priority: priority,
                      dueDate: dueDate,
                    ));
                  });
                  _saveTasks();
                  Navigator.pop(context);
                }
              },
              child: const Text('افزودن'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddShoppingDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('آیتم جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'نام محصول',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد (اختیاری)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _shoppingList.add(ShoppingItem(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    quantity: quantityController.text.isNotEmpty 
                        ? int.tryParse(quantityController.text) 
                        : null,
                  ));
                });
                _saveShoppingList();
                Navigator.pop(context);
              }
            },
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('یادداشت جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان (اختیاری)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'محتوا',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                setState(() {
                  _notes.add(Note(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  ));
                });
                _saveNotes();
                Navigator.pop(context);
              }
            },
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ویرایش یادداشت'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'محتوا',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                setState(() {
                  note.title = titleController.text;
                  note.content = contentController.text;
                });
                _saveNotes();
                Navigator.pop(context);
              }
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Models
class Task {
  final String id;
  final String title;
  final int priority;
  final DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.priority = 1,
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'priority': priority,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    priority: map['priority'] ?? 1,
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    isCompleted: map['isCompleted'] ?? false,
  );
}

class ShoppingItem {
  final String id;
  final String name;
  final int? quantity;
  bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity,
    this.isPurchased = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'isPurchased': isPurchased,
  };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
    id: map['id'],
    name: map['name'],
    quantity: map['quantity'],
    isPurchased: map['isPurchased'] ?? false,
  );
}

class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'] ?? '',
    content: map['content'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
