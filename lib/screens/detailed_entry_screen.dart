import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../screens/editentryscreen.dart';

class EntryDetailScreen extends StatefulWidget {
  final Entry entry;

  const EntryDetailScreen({super.key, required this.entry});

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late Entry _currentEntry;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
  }

  Future<void> _navigateToEdit() async {
    final updated = await Navigator.push<Entry>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryScreen(entry: _currentEntry),
      ),
    );

    if (updated != null) {
      setState(() {
        _currentEntry = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _currentEntry);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _currentEntry),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentEntry.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                _currentEntry.date.toString().split(' ')[0],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              if (_currentEntry.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _currentEntry.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: colorScheme.secondaryContainer,
                      labelStyle: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              const Divider(),
              const SizedBox(height: 16),

              Text(
                _currentEntry.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToEdit,
          tooltip: 'Edit entry',
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}