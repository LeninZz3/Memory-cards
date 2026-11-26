import 'package:flutter/material.dart';
import '../models/entry.dart';

class EditEntryScreen extends StatefulWidget {
  final Entry entry;

  const EditEntryScreen({super.key, required this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late TextEditingController _tagsController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _textController = TextEditingController(text: widget.entry.text);
    _tagsController = TextEditingController(text: widget.entry.tags.join(', '));
    _selectedDate = widget.entry.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // Dátumválasztó dialógus megnyitása
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty || _textController.text.trim().isEmpty) {
      return;
    }

    final tagsList = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();


    final updatedEntry = Entry(
      id: widget.entry.id,
      title: _titleController.text,
      text: _textController.text,
      date: _selectedDate,
      tags: tagsList,
    );

    Navigator.pop(context, updatedEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
            tooltip: 'Save changes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${_selectedDate.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Change Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),


            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'e.g. work, flutter, idea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 250,
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Memory text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}