class Nota {
  final int id;
  final int temaId;
  final String? nombre;
  final String? descripcion;
  final DateTime? fechaNotificacion;
  final DateTime createdAt;
  final DateTime updatedAt;

  Nota({
    required this.id,
    required this.temaId,
    this.nombre,
    this.descripcion,
    this.fechaNotificacion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'],
      temaId: json['tema_id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaNotificacion: json['fecha_notificacion'] != null
          ? DateTime.parse(json['fecha_notificacion'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tema_id': temaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_notificacion': fechaNotificacion?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
