import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:highlight_text/highlight_text.dart';
import '../models/entry.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final String searchQuery;

  const EntryCard({
    super.key,
    required this.entry,
    required this.searchQuery,
  });

  Color _tagColor(String tag) {
    const colors = {
      'Travel': Colors.blue,
      'Food': Colors.orange,
      'Erasmus': Colors.purple,
      'Ideas': Colors.green,
      'Culture': Colors.red,
      'Other': Colors.grey,
      'Work': Colors.blue,
      'Personal': Colors.amber,
      'Idea': Colors.green,
      'Important': Colors.red,
    };
    return colors[tag] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = searchQuery.trim().toLowerCase();

    final Map<String, HighlightedWord> highlights = query.isEmpty
        ? {}
        : {
      query: HighlightedWord(
        textStyle: TextStyle(
          color: isDark ? Colors.black : Colors.deepPurple,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.yellowAccent,
        ),
      ),
    };

    return Card(
      elevation: 15.0,
      color: isDark ? const Color(0xFF1E1E2C) : Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 3,
                  color: isDark ? Colors.purpleAccent : Colors.deepPurple,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextHighlight(
                      text: entry.title,
                      words: highlights,
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.purple.shade200 : Colors.deepPurple,
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ) ??
                          const TextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.auto_stories,
                  size: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(entry.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey.shade400 : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            entry.text.trim().isEmpty
                ? Text(
              'No description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey.shade500 : Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            )
                : TextHighlight(
              text: entry.text,
              words: highlights,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey.shade200 : Colors.black87,
              ) ??
                  const TextStyle(),
            ),
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: entry.tags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: _tagColor(tag).withValues(alpha: isDark ? 0.35 : 0.2),
                    side: BorderSide(color: _tagColor(tag)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}