import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_provider.dart';

class ChapterEditScreen extends StatefulWidget {
  const ChapterEditScreen({super.key});

  @override
  State<ChapterEditScreen> createState() => _ChapterEditScreenState();
}

class _ChapterEditScreenState extends State<ChapterEditScreen> {
  final List<Map<String, dynamic>> _chapters = [
    {
      'id': 'math_1',
      'title': 'Numbers and Counting',
      'subject': 'Mathematics',
      'grade': '5',
      'content': '''
Numbers help us count and measure things in our daily life.

1. **Natural Numbers**: 1, 2, 3, 4, ...
2. **Whole Numbers**: 0, 1, 2, 3, ...
3. **Place Value**: Hundreds, Tens, Ones
4. **Counting**: Forward and backward counting

**Example**: 256 = 2 hundreds + 5 tens + 6 ones
      ''',
      'topics': ['Counting', 'Place Value', 'Addition', 'Subtraction'],
    },
    {
      'id': 'science_1',
      'title': 'Photosynthesis',
      'subject': 'Science',
      'grade': '5',
      'content': '''
**Photosynthesis** is the process by which plants make their own food.

**Process**:
1. Sunlight provides energy
2. Carbon dioxide from air
3. Water from soil
4. Chlorophyll in leaves

**Formula**: 
Sunlight + Water + Carbon Dioxide → Glucose + Oxygen

Plants are essential for life on Earth!
      ''',
      'topics': ['Plant Biology', 'Energy Conversion', 'Oxygen Production'],
    },
    {
      'id': 'english_1',
      'title': 'Basic Grammar',
      'subject': 'English',
      'grade': '5',
      'content': '''
**Grammar Basics**:

1. **Nouns**: Names of people, places, things
   - Example: school, teacher, book

2. **Verbs**: Action words
   - Example: run, read, write

3. **Adjectives**: Describing words
   - Example: big, happy, blue

4. **Sentences**: Complete thoughts
   - Example: I read a book.
      ''',
      'topics': ['Parts of Speech', 'Sentence Structure', 'Punctuation'],
    },
  ];

  final Map<String, TextEditingController> _contentControllers = {};
  final Map<String, TextEditingController> _topicControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each chapter
    for (var chapter in _chapters) {
      _contentControllers[chapter['id']] = 
          TextEditingController(text: chapter['content']);
      _topicControllers[chapter['id']] = 
          TextEditingController(text: chapter['topics'].join(', '));
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _contentControllers.values) {
      controller.dispose();
    }
    for (var controller in _topicControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveChapter(String chapterId) {
    final content = _contentControllers[chapterId]!.text;
    final topics = _topicControllers[chapterId]!.text.split(',').map((t) => t.trim()).toList();
    
    // Update the chapter in the list
    final chapterIndex = _chapters.indexWhere((c) => c['id'] == chapterId);
    if (chapterIndex != -1) {
      setState(() {
        _chapters[chapterIndex]['content'] = content;
        _chapters[chapterIndex]['topics'] = topics;
      });
    }

    // Update in provider
    Provider.of<TeacherProvider>(context, listen: false)
        .updateChapterContent(chapterId, content);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter updated successfully!')),
    );
  }

  void _addNewChapter() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final subjectController = TextEditingController();
        final gradeController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Add New Chapter'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Chapter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newChapter = {
                  'id': 'new_${DateTime.now().millisecondsSinceEpoch}',
                  'title': titleController.text,
                  'subject': subjectController.text,
                  'grade': gradeController.text,
                  'content': 'Enter chapter content here...',
                  'topics': [],
                };
                
                setState(() {
                  _chapters.add(newChapter);
                  _contentControllers[newChapter['id'] as String] = 
                      TextEditingController(text: newChapter['content'] as String);
                  _topicControllers[newChapter['id'] as String] = 
                      TextEditingController(text: '');
                });
                
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _chapters.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Chapters'),
          backgroundColor: const Color(0xFF2C3E50),
          bottom: TabBar(
            isScrollable: true,
            tabs: _chapters.map((chapter) {
              return Tab(text: chapter['title']);
            }).toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addNewChapter,
            ),
          ],
        ),
        body: TabBarView(
          children: _chapters.map((chapter) {
            final chapterId = chapter['id'];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(chapter['subject']),
                                backgroundColor: Colors.blue[50],
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text('Grade ${chapter['grade']}'),
                                backgroundColor: Colors.green[50],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content editor
                  const Text(
                    'Chapter Content',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use Markdown format for rich text (**, #, 1., etc.)',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _contentControllers[chapterId],
                      maxLines: 15,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                        hintText: 'Enter chapter content here...',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Topics editor
                  const Text(
                    'Topics Covered',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter topics separated by commas',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _topicControllers[chapterId],
                    decoration: const InputDecoration(
                      labelText: 'Topics',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Counting, Addition, Subtraction',
                    ),
                  ),
                  
                  // Current topics
                  if (chapter['topics'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Current Topics:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: (chapter['topics'] as List<String>).map((topic) {
                            return Chip(
                              label: Text(topic),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  chapter['topics'].remove(topic);
                                  _topicControllers[chapterId]!.text = 
                                      (chapter['topics'] as List<String>).join(', ');
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 30),
                  
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _saveChapter(chapterId),
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'SAVE CHANGES',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}