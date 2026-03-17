import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  final List<Map<String, dynamic>> chapters = const [
    {
      'id': 'math_1',
      'title': 'Numbers and Counting',
      'subject': 'Mathematics',
      'grade': '5',
      'duration': '30 mins',
      'icon': Icons.numbers,
      'color': Colors.blue,
    },
    {
      'id': 'science_1',
      'title': 'Photosynthesis',
      'subject': 'Science',
      'grade': '5',
      'duration': '45 mins',
      'icon': Icons.nature,
      'color': Colors.green,
    },
    {
      'id': 'english_1',
      'title': 'Basic Grammar',
      'subject': 'English',
      'grade': '5',
      'duration': '25 mins',
      'icon': Icons.language,
      'color': Colors.purple,
    },
    {
      'id': 'social_1',
      'title': 'Our Country',
      'subject': 'Social Studies',
      'grade': '5',
      'duration': '40 mins',
      'icon': Icons.public,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHAPTERS'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Materials',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Study offline at your own pace',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailScreen(
                            chapterId: chapter['id'],
                            chapterTitle: chapter['title'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: chapter['color']!.withOpacity(0.2),
                              child: Icon(
                                chapter['icon'],
                                color: chapter['color'],
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              chapter['subject'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chapter['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  chapter['duration'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterDetailScreen extends StatelessWidget {
  final String chapterId;
  final String chapterTitle;

  const ChapterDetailScreen({
    super.key,
    required this.chapterId,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chapter Content',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChapterContent(chapterId),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Key Points',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildKeyPoints(chapterId),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterContent(String chapterId) {
    final content = {
      'math_1': '''
Numbers help us count and measure things in our daily life.

1. **Natural Numbers**: 1, 2, 3, 4, ...
2. **Whole Numbers**: 0, 1, 2, 3, ...
3. **Place Value**: Hundreds, Tens, Ones
4. **Counting**: Forward and backward counting

**Example**: 256 = 2 hundreds + 5 tens + 6 ones
      ''',
      'science_1': '''
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
      'english_1': '''
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
    };

    return Text(
      content[chapterId] ?? 'Content loading...',
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  Widget _buildKeyPoints(String chapterId) {
    final keyPoints = {
      'math_1': const [
        'Numbers have place value',
        'Zero is important',
        'Count in groups of ten',
        'Practice makes perfect',
      ],
      'science_1': const [
        'Plants make their own food',
        'Sunlight is essential',
        'Produces oxygen for us',
        'Leaves are food factories',
      ],
      'english_1': const [
        'Every sentence needs a verb',
        'Capitalize proper nouns',
        'Use punctuation correctly',
        'Practice speaking daily',
      ],
    };

    final points = keyPoints[chapterId] ?? ['Study regularly'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}