class Tema {
  // Propiedades de la clase
  final int id;                // ID único del tema (requerido)
  final int usuarioId;         // ID del usuario dueño del tema (requerido)
  final String nombre;         // Nombre del tema (requerido)
  final bool poseeCalendario;  // Indica si el tema tiene calendario asociado (requerido)
  final String createdAt;      // Fecha de creación como String (requerido)
  final String updatedAt;      // Fecha de última actualización como String (requerido)

  // Constructor principal
  Tema({
    required this.id,            // Parámetro requerido: ID del tema
    required this.usuarioId,     // Parámetro requerido: ID del usuario
    required this.nombre,        // Parámetro requerido: nombre del tema
    required this.poseeCalendario, // Parámetro requerido: indicador de calendario
    required this.createdAt,     // Parámetro requerido: fecha creación (String)
    required this.updatedAt,     // Parámetro requerido: fecha actualización (String)
  });

  // Constructor factory para crear un Tema desde JSON
  factory Tema.fromJson(Map<String, dynamic> json) {
    return Tema(
      id: json['id'],                   // Obtiene ID del JSON
      usuarioId: json['usuario_id'],     // Obtiene usuario_id del JSON
      nombre: json['nombre'],            // Obtiene nombre del tema del JSON
      poseeCalendario: json['posee_calendario'], // Obtiene booleano de calendario
      createdAt: json['created_at'],     // Obtiene fecha creación como String
      updatedAt: json['updated_at'],     // Obtiene fecha actualización como String
    );
  }
}