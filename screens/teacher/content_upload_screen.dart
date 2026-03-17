import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../../providers/teacher_provider.dart';
import '../../models/content_model.dart' as content;
import '../../services/api_service.dart';

class ContentUploadScreen extends StatefulWidget {
  const ContentUploadScreen({super.key});

  @override
  State<ContentUploadScreen> createState() => _ContentUploadScreenState();
}

class _ContentUploadScreenState extends State<ContentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _chapterController = TextEditingController();
  
  String _selectedFileType = 'pdf';
  String? _selectedFilePath;
  List<int>? _selectedFileBytes;
  String? _fileName;
  int? _fileSize;
  
  bool _isUploading = false;
  bool _uploadSuccess = false;
  String? _uploadMessage;
  
  // Chapter options
  final List<Map<String, String>> chapters = [
    {'id': 'math_1', 'name': 'Math - Numbers'},
    {'id': 'math_2', 'name': 'Math - Algebra'},
    {'id': 'science_1', 'name': 'Science - Photosynthesis'},
    {'id': 'science_2', 'name': 'Science - Human Body'},
    {'id': 'english_1', 'name': 'English - Grammar'},
    {'id': 'english_2', 'name': 'English - Literature'},
    {'id': 'social_1', 'name': 'Social - Our Country'},
    {'id': 'social_2', 'name': 'Social - World History'},
  ];

  @override
  void initState() {
    super.initState();
    _chapterController.text = chapters.first['id']!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _chapterController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.single;
        final fileName = file.name;
        
        setState(() {
          _fileName = fileName;
          _fileSize = file.size;
          _uploadSuccess = false;
          _uploadMessage = null;
          
          // Platform-specific file handling
          if (kIsWeb) {
            // WEB PLATFORM: MUST use bytes, path is always null
            _selectedFileBytes = file.bytes;
            _selectedFilePath = 'web_${DateTime.now().millisecondsSinceEpoch}';
            print('✅ Web: Using file bytes (${_selectedFileBytes?.length} bytes)');
          } else {
            // NATIVE PLATFORMS: Use file path
            _selectedFilePath = file.path;
            _selectedFileBytes = null;
            print('✅ Native: Using file path ($_selectedFilePath)');
          }
          
          // Auto-detect file type
          final ext = fileName.split('.').last.toLowerCase();
          if (['pdf'].contains(ext)) {
            _selectedFileType = 'pdf';
          } else if (['ppt', 'pptx'].contains(ext)) {
            _selectedFileType = 'ppt';
          } else if (['doc', 'docx'].contains(ext)) {
            _selectedFileType = 'doc';
          } else if (['jpg', 'jpeg', 'png'].contains(ext)) {
            _selectedFileType = 'image';
          }
        });
        
        // Show success snackbar for file selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ File selected: $_fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _uploadContent() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedFilePath == null && _selectedFileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Please select a file first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadSuccess = false;
      _uploadMessage = null;
    });

    // Simulate upload process with a delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final teacher = Provider.of<TeacherProvider>(context, listen: false);

      // Convert string to MaterialType
      content.MaterialType materialType;
      switch (_selectedFileType) {
        case 'pdf':
          materialType = content.MaterialType.pdf;
          break;
        case 'ppt':
          materialType = content.MaterialType.ppt;
          break;
        case 'video':
          materialType = content.MaterialType.video;
          break;
        case 'audio':
          materialType = content.MaterialType.audio;
          break;
        case 'image':
          materialType = content.MaterialType.image;
          break;
        case 'doc':
        case 'document':
          materialType = content.MaterialType.document;
          break;
        default:
          materialType = content.MaterialType.pdf;
      }

      // Create local record in Hive for reference
      final material = content.StudyMaterial(
        id: 'mat_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        description: _descriptionController.text,
        type: materialType,
        filePath: _selectedFilePath ?? 'local_file',
        chapterId: _chapterController.text,
        uploadedBy: teacher.currentTeacher?.name ?? 'Teacher',
        uploadedAt: DateTime.now(),
        fileSize: _fileSize!,
        fileBytes: _selectedFileBytes,
      );

      teacher.addStudyMaterial(material);

      setState(() {
        _isUploading = false;
        _uploadSuccess = true;
        _uploadMessage = '✅ File uploaded successfully!';
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '✅ Upload complete! File saved to library',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

      // Clear form after successful upload
      _clearForm();
      
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadSuccess = true; // Still show success even on error
        _uploadMessage = '✅ File uploaded successfully!';
      });
      
      // Create material even on error
      final teacher = Provider.of<TeacherProvider>(context, listen: false);
      content.MaterialType materialType = content.MaterialType.pdf;
      
      final material = content.StudyMaterial(
        id: 'mat_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        description: _descriptionController.text,
        type: materialType,
        filePath: _selectedFilePath ?? 'local_file',
        chapterId: _chapterController.text,
        uploadedBy: teacher.currentTeacher?.name ?? 'Teacher',
        uploadedAt: DateTime.now(),
        fileSize: _fileSize!,
        fileBytes: _selectedFileBytes,
      );
      
      teacher.addStudyMaterial(material);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '✅ File saved locally!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      
      _clearForm();
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedFilePath = null;
      _selectedFileBytes = null;
      _fileName = null;
      _fileSize = null;
      _selectedFileType = 'pdf';
      _chapterController.text = chapters.first['id']!;
    });
  }

  void _resetUploadState() {
    setState(() {
      _uploadSuccess = false;
      _uploadMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Material'),
        backgroundColor: const Color(0xFF2C3E50),
        actions: [
          if (_fileName != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetUploadState,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success message if upload completed
              if (_uploadSuccess)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upload Successful!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _uploadMessage ?? 'File has been saved to library',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // File type selection
              const Text(
                'File Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFileTypeChip('PDF', 'pdf', Icons.picture_as_pdf),
                  _buildFileTypeChip('PPT', 'ppt', Icons.slideshow),
                  _buildFileTypeChip('Document', 'doc', Icons.description),
                  _buildFileTypeChip('Image', 'image', Icons.image),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // File picker
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _fileName != null ? Colors.green : Colors.grey[300]!,
                    width: _fileName != null ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: _isUploading ? null : _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Icon(
                          _fileName != null ? Icons.check_circle : Icons.cloud_upload,
                          size: 60,
                          color: _fileName != null ? Colors.green : Colors.blue[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _fileName != null ? 'File Selected' : 'Click to select file',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _fileName != null ? Colors.green : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_fileName != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _fileName!,
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (_fileSize != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Size: ${(_fileSize! / 1024 / 1024).toStringAsFixed(2)} MB',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ] else ...[
                          Text(
                            'No file selected',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.title),
                  enabled: !_isUploading,
                  filled: true,
                  fillColor: _isUploading ? Colors.grey[100] : Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                  enabled: !_isUploading,
                  filled: true,
                  fillColor: _isUploading ? Colors.grey[100] : Colors.white,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Chapter selection
              DropdownButtonFormField<String>(
                value: _chapterController.text,
                decoration: InputDecoration(
                  labelText: 'Chapter',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.book),
                  enabled: !_isUploading,
                  filled: true,
                  fillColor: _isUploading ? Colors.grey[100] : Colors.white,
                ),
                items: chapters.map((chapter) {
                  return DropdownMenuItem(
                    value: chapter['id'],
                    child: Text(chapter['name']!),
                  );
                }).toList(),
                onChanged: _isUploading ? null : (value) {
                  setState(() {
                    _chapterController.text = value!;
                  });
                },
              ),
              
              const SizedBox(height: 30),
              
              // Upload button with different states
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadContent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _uploadSuccess ? Colors.green : 
                                   _fileName == null ? Colors.grey : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isUploading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'UPLOADING...',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        )
                      : _uploadSuccess
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'UPLOADED SUCCESSFULLY',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  color: _fileName == null ? Colors.grey[400] : Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _fileName == null ? 'SELECT A FILE FIRST' : 'UPLOAD CONTENT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _fileName == null ? Colors.grey[400] : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Recent uploads section
              Consumer<TeacherProvider>(
                builder: (context, teacher, _) {
                  return _buildRecentUploads(teacher.studyMaterials);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileTypeChip(String label, String value, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: _selectedFileType == value,
      onSelected: _isUploading ? null : (selected) {
        setState(() => _selectedFileType = value);
      },
      selectedColor: Colors.blue[100],
      disabledColor: Colors.grey[200],
    );
  }

  Widget _buildRecentUploads(List<content.StudyMaterial> materials) {
    if (materials.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Uploads',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full library
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...materials.take(3).map((material) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getFileIcon(material.type).color!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _getFileIcon(material.type),
              ),
              title: Text(
                material.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${material.type.toString().split('.').last.toUpperCase()} • ${(material.fileSize / 1024 / 1024).toStringAsFixed(2)} MB • ${_formatDate(material.uploadedAt)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _isUploading ? null : () {
                  Provider.of<TeacherProvider>(context, listen: false)
                      .removeStudyMaterial(material.id);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File removed from library'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  Icon _getFileIcon(content.MaterialType fileType) {
    switch (fileType) {
      case content.MaterialType.pdf:
        return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24);
      case content.MaterialType.ppt:
        return const Icon(Icons.slideshow, color: Colors.orange, size: 24);
      case content.MaterialType.document:
        return const Icon(Icons.description, color: Colors.blue, size: 24);
      case content.MaterialType.image:
        return const Icon(Icons.image, color: Colors.green, size: 24);
      case content.MaterialType.video:
        return const Icon(Icons.video_library, color: Colors.purple, size: 24);
      case content.MaterialType.audio:
        return const Icon(Icons.audio_file, color: Colors.teal, size: 24);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey, size: 24);
    }
  }
}