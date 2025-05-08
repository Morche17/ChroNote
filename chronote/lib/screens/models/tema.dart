class Tema {
  final int id;
  final int usuarioId;
  final String nombre;
  final bool poseeCalendario;
  final String createdAt;
  final String updatedAt;

  Tema({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.poseeCalendario,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tema.fromJson(Map<String, dynamic> json) {
    return Tema(
      id: json['id'],
      usuarioId: json['usuario_id'],
      nombre: json['nombre'],
      poseeCalendario: json['posee_calendario'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
