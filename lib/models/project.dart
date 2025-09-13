import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final double rating;
  @HiveField(4)
  final int interactions;
  @HiveField(5)
  final String unit;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final bool isNew;
  @HiveField(8)
  bool isFavorited; // Pode ser alterado
  @HiveField(9)
  final String responsibleArea;
  @HiveField(10)
  final String responsiblePerson;
  @HiveField(11)
  final String technology;
  @HiveField(12)
  final String description;
  @HiveField(13)
  final DateTime estimatedCompletionDate;
  @HiveField(14)
  final DateTime criticalDate;
  @HiveField(15)
  final String? ownerUserId; // ID do usuário proprietário (para Firebase)
  @HiveField(16)
  final DateTime? createdAt; // Data de criação
  @HiveField(17)
  final DateTime? updatedAt; // Data da última atualização

  Project({
    required this.id,
    required this.name,
    required this.category,
    this.rating = 5.0,
    this.interactions = 0,
    required this.unit,
    required this.status,
    this.isNew = false,
    this.isFavorited = false,
    required this.responsibleArea,
    required this.responsiblePerson,
    required this.technology,
    required this.description,
    required this.estimatedCompletionDate,
    required this.criticalDate,
    this.ownerUserId,
    this.createdAt,
    this.updatedAt,
  });

  // Converte um Map em um objeto Project
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] ?? UniqueKey().toString(), // Gerar um ID se não existir
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      interactions: map['interactions'] ?? 0,
      unit: map['unit'] ?? '',
      status: map['status'] ?? '',
      isNew: map['isNew'] ?? false,
      isFavorited: map['isFavorited'] ?? false,
      responsibleArea: map['responsibleArea'] ?? '',
      responsiblePerson: map['responsiblePerson'] ?? '',
      technology: map['technology'] ?? '',
      description: map['description'] ?? '',
      estimatedCompletionDate: map['estimatedCompletionDate'] is String
          ? DateTime.parse(map['estimatedCompletionDate'])
          : map['estimatedCompletionDate'] ?? DateTime.now(),
      criticalDate: map['criticalDate'] is String
          ? DateTime.parse(map['criticalDate'])
          : map['criticalDate'] ?? DateTime.now(),
      ownerUserId: map['ownerUserId'],
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'])
          : map['createdAt'],
      updatedAt: map['updatedAt'] is String
          ? DateTime.parse(map['updatedAt'])
          : map['updatedAt'],
    );
  }

  // Converte um objeto Project em um Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'interactions': interactions,
      'unit': unit,
      'status': status,
      'isNew': isNew,
      'isFavorited': isFavorited,
      'responsibleArea': responsibleArea,
      'responsiblePerson': responsiblePerson,
      'technology': technology,
      'description': description,
      'estimatedCompletionDate': estimatedCompletionDate.toIso8601String(),
      'criticalDate': criticalDate.toIso8601String(),
      'ownerUserId': ownerUserId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Permite criar uma cópia de um projeto com valores atualizados
  Project copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? interactions,
    String? unit,
    String? status,
    bool? isNew,
    bool? isFavorited,
    String? responsibleArea,
    String? responsiblePerson,
    String? technology,
    String? description,
    DateTime? estimatedCompletionDate,
    DateTime? criticalDate,
    String? ownerUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      interactions: interactions ?? this.interactions,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      isNew: isNew ?? this.isNew,
      isFavorited: isFavorited ?? this.isFavorited,
      responsibleArea: responsibleArea ?? this.responsibleArea,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      technology: technology ?? this.technology,
      description: description ?? this.description,
      estimatedCompletionDate:
          estimatedCompletionDate ?? this.estimatedCompletionDate,
      criticalDate: criticalDate ?? this.criticalDate,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
