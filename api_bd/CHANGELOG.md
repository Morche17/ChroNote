# Changelog

## 0.1.0
* CRUD
  * La api puede recibir peticiones para registro, actualización, lectura y borrado de usuarios.
  * La contraseña se encripta al momento de almacenarse dentro de la base de datos.
  * La consulta de usuarios o por usuario individual solamente muestra nombre, correo e id por el momento.

## 0.1.1
* Notas y temas
	* La api puede recibir peticiones para crear, modificar, borrar y leer temas y notas.
	* Cada tema está relacionado a un usuario; teniendo cada tema un usuario y un usuario pudiendo tener múltiples temas. Así mismo un tema puede tener múltiples notas pero cada nota puede pertenecer a un tema (por el momento).