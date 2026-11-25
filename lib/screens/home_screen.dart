import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../widgets/entry_card.dart';
import 'create_entry_screen.dart';
import '../utils/storage.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> _entries = [];
  String _searchQuery = '';

  List<Entry> get _filteredEntries {
    if (_searchQuery.isEmpty) return _entries;
    final query = _searchQuery.toLowerCase();
    return _entries.where((entry) {
      return entry.title.toLowerCase().contains(query) ||
          entry.text.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadStoredEntries();
  }

  Future<void> _loadStoredEntries() async {
    final loaded = await loadEntries();
    setState(() {
      _entries = loaded;
    });
  }

  Future<void> _openCreateScreen() async {
    final newEntry = await Navigator.push<Entry>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEntryScreen(),
      ),
    );
    if (newEntry != null) {
      setState(() {
        _entries.insert(0, newEntry);
      });
      saveEntries(_entries);
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_stories, color: Colors.deepPurple),
            SizedBox(width: 4),
            Text('About'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Developer: Horvath Lajos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('App version: v1.0.1'),
            const SizedBox(height: 4),
            const Text('Created with Flutter & Dart'),
            const SizedBox(height: 4),
            Text('Total saved memories: ${_entries.length}'),
            const SizedBox(height: 12),
            const Text(
              'App created whilst in the Erasmus+ program in Germany, Schkeuditz.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'App Info',
            onPressed: _showInfoDialog,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all memories',
            onPressed: _entries.isEmpty
                ? null
                : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear all memories?'),
                  content: const Text(
                      'This will delete all entries. This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                setState(() {
                  _entries.clear();
                });
                saveEntries(_entries);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search memories...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: _buildFeed(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateScreen,
        tooltip: 'Add memory',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeed() {
    final filtered = _filteredEntries;

    if (_searchQuery.isEmpty && _entries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No memories yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to create your first one!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_searchQuery.isNotEmpty && filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No results found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final entry = filtered[index];
        return Dismissible(
          key: ValueKey(entry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete entry?'),
                content: const Text('This cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
                false;
          },
          onDismissed: (direction) {
            final originalIndex = _entries.indexOf(entry);
            final deletedEntry = entry;
            final deletedIndex = originalIndex;

            setState(() => _entries.removeAt(originalIndex));
            saveEntries(_entries);

            ScaffoldMessenger.of(context).clearSnackBars();

            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Memory deleted.',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue.shade800,
                duration: const Duration(days: 1),
                action: SnackBarAction(
                  label: 'Undo',
                  textColor: Colors.yellowAccent,
                  onPressed: () {
                    setState(() {
                      _entries.insert(deletedIndex, deletedEntry);
                    });
                    saveEntries(_entries);
                  },
                ),
              ),
            );

            Future.delayed(const Duration(seconds: 10), () {
              controller.close();
            });
          },
          child: EntryCard(
            entry: entry,
            searchQuery: _searchQuery,
          ),
        );
      },
    );
  }
}