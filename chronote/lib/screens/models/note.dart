class Nota {
  // Propiedades de la clase
  final int id;                 // ID único de la nota
  final int temaId;             // ID del tema relacionado
  final String? nombre;         // Nombre/título de la nota (opcional)
  final String? descripcion;    // Descripción/contenido (opcional)
  final DateTime? fechaNotificacion; // Fecha para notificación (opcional)
  final DateTime createdAt;     // Fecha de creación
  final DateTime updatedAt;     // Fecha de última actualización

  // Constructor principal
  Nota({
    required this.id,           // Requerido: ID de la nota
    required this.temaId,       // Requerido: ID del tema
    this.nombre,                // Opcional: nombre
    this.descripcion,           // Opcional: descripción
    this.fechaNotificacion,     // Opcional: fecha de notificación
    required this.createdAt,    // Requerido: fecha creación
    required this.updatedAt,    // Requerido: fecha actualización
  });

  // Constructor factory para crear una Nota desde JSON
  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'],           // Obtiene ID del JSON
      temaId: json['tema_id'],   // Obtiene tema_id del JSON
      nombre: json['nombre'],    // Obtiene nombre (puede ser null)
      descripcion: json['descripcion'], // Obtiene descripción (puede ser null)
      // Convierte string a DateTime si fecha_notificacion existe
      fechaNotificacion: json['fecha_notificacion'] != null
          ? DateTime.parse(json['fecha_notificacion'])
          : null,
      // Parsea fecha de creación desde string
      createdAt: DateTime.parse(json['created_at']),
      // Parsea fecha de actualización desde string
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convierte la Nota a formato JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,                       // Agrega ID
      'tema_id': temaId,               // Agrega tema_id
      'nombre': nombre,                // Agrega nombre (puede ser null)
      'descripcion': descripcion,       // Agrega descripción (puede ser null)
      // Convierte DateTime a string ISO si existe fechaNotificacion
      'fecha_notificacion': fechaNotificacion?.toIso8601String(),
      // Convierte createdAt a string ISO
      'created_at': createdAt.toIso8601String(),
      // Convierte updatedAt a string ISO
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}