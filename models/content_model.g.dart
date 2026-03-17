// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterContentAdapter extends TypeAdapter<ChapterContent> {
  @override
  final int typeId = 5;

  @override
  ChapterContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterContent(
      id: fields[0] as String,
      title: fields[1] as String,
      subject: fields[2] as String,
      grade: fields[3] as String,
      content: fields[4] as String,
      topics: (fields[5] as List).cast<String>(),
      imagePath: fields[6] as String?,
      quizId: fields[7] as String?,
      duration: fields[8] as Duration,
      lastUpdated: fields[9] as DateTime,
      updatedBy: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChapterContent obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.grade)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.topics)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.quizId)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.lastUpdated)
      ..writeByte(10)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudyMaterialAdapter extends TypeAdapter<StudyMaterial> {
  @override
  final int typeId = 6;

  @override
  StudyMaterial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyMaterial(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as MaterialType,
      filePath: fields[4] as String,
      chapterId: fields[5] as String,
      uploadedBy: fields[6] as String,
      uploadedAt: fields[7] as DateTime,
      fileSize: fields[8] as int,
      downloadCount: fields[9] as int,
      tags: (fields[10] as List).cast<String>(),
      fileBytes: (fields[11] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudyMaterial obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.chapterId)
      ..writeByte(6)
      ..write(obj.uploadedBy)
      ..writeByte(7)
      ..write(obj.uploadedAt)
      ..writeByte(8)
      ..write(obj.fileSize)
      ..writeByte(9)
      ..write(obj.downloadCount)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.fileBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnnouncementAdapter extends TypeAdapter<Announcement> {
  @override
  final int typeId = 8;

  @override
  Announcement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Announcement(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      createdBy: fields[3] as String,
      createdAt: fields[4] as DateTime,
      expiresAt: fields[5] as DateTime?,
      isImportant: fields[6] as bool,
      targetClasses: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Announcement obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.expiresAt)
      ..writeByte(6)
      ..write(obj.isImportant)
      ..writeByte(7)
      ..write(obj.targetClasses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssignmentAdapter extends TypeAdapter<Assignment> {
  @override
  final int typeId = 9;

  @override
  Assignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assignment(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      chapterId: fields[3] as String,
      assignedBy: fields[4] as String,
      assignedDate: fields[5] as DateTime,
      dueDate: fields[6] as DateTime,
      totalPoints: fields[7] as int,
      attachments: (fields[8] as List).cast<String>(),
      submissions: (fields[9] as Map).cast<String, String>(),
      grades: (fields[10] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Assignment obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.chapterId)
      ..writeByte(4)
      ..write(obj.assignedBy)
      ..writeByte(5)
      ..write(obj.assignedDate)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.totalPoints)
      ..writeByte(8)
      ..write(obj.attachments)
      ..writeByte(9)
      ..write(obj.submissions)
      ..writeByte(10)
      ..write(obj.grades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MaterialTypeAdapter extends TypeAdapter<MaterialType> {
  @override
  final int typeId = 7;

  @override
  MaterialType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MaterialType.pdf;
      case 1:
        return MaterialType.ppt;
      case 2:
        return MaterialType.video;
      case 3:
        return MaterialType.audio;
      case 4:
        return MaterialType.image;
      case 5:
        return MaterialType.document;
      case 6:
        return MaterialType.link;
      default:
        return MaterialType.pdf;
    }
  }

  @override
  void write(BinaryWriter writer, MaterialType obj) {
    switch (obj) {
      case MaterialType.pdf:
        writer.writeByte(0);
        break;
      case MaterialType.ppt:
        writer.writeByte(1);
        break;
      case MaterialType.video:
        writer.writeByte(2);
        break;
      case MaterialType.audio:
        writer.writeByte(3);
        break;
      case MaterialType.image:
        writer.writeByte(4);
        break;
      case MaterialType.document:
        writer.writeByte(5);
        break;
      case MaterialType.link:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
