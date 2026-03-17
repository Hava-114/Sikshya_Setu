// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 10;

  @override
  Teacher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Teacher(
      id: fields[0] as String,
      username: fields[1] as String,
      name: fields[2] as String,
      email: fields[3] as String,
      school: fields[4] as String,
      assignedClasses: (fields[5] as List).cast<String>(),
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.school)
      ..writeByte(5)
      ..write(obj.assignedClasses)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudentProgressAdapter extends TypeAdapter<StudentProgress> {
  @override
  final int typeId = 11;

  @override
  StudentProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentProgress(
      studentId: fields[0] as String,
      studentName: fields[1] as String,
      totalPoints: fields[2] as int,
      completedQuizzes: fields[3] as int,
      totalQuizzes: fields[4] as int,
      averageScore: fields[5] as double,
      badges: (fields[6] as List).cast<String>(),
      lastActive: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StudentProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.studentName)
      ..writeByte(2)
      ..write(obj.totalPoints)
      ..writeByte(3)
      ..write(obj.completedQuizzes)
      ..writeByte(4)
      ..write(obj.totalQuizzes)
      ..writeByte(5)
      ..write(obj.averageScore)
      ..writeByte(6)
      ..write(obj.badges)
      ..writeByte(7)
      ..write(obj.lastActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudyMaterialAdapter extends TypeAdapter<StudyMaterial> {
  @override
  final int typeId = 12;

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
      fileType: fields[3] as String,
      filePath: fields[4] as String,
      chapterId: fields[5] as String,
      uploadedBy: fields[6] as String,
      uploadedAt: fields[7] as DateTime,
      fileSize: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudyMaterial obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.fileType)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.chapterId)
      ..writeByte(6)
      ..write(obj.uploadedBy)
      ..writeByte(7)
      ..write(obj.uploadedAt)
      ..writeByte(8)
      ..write(obj.fileSize);
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
