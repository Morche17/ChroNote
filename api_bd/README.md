# API para conexión con la base de datos

* Ruby version
	* Para la creación de la api utilicé la versión 3.4.2

* System dependencies
	* mysql2 ~> 0.5
	* rails ~> 8.0.2
	* puma 5.0
	* jbuilder
	* bcrypt ~> 3.1.7
	* tzinfo-data
	* solid_cache
	* solid_queue
	* solid_cable
	* bootsnap
	* kamal
	* thruster
	* debug
	* brakeman
	* rubocop-rails-omakase

* Configuration

Todas las dependencias se encuentran en el ```Gemfile```. Para instalarlas basta con escribir en terminal ```bundle install```.

* Database creation
 
Necesita crearse una base de datos en mysql/mariadb con el nombre ```chronotebd_test```. Después hay que crear un usuario y contraseña para acceder a esa base de datos (si no quiere usar root). Por ejemplo:

>**Usuario**: chronoteadmin

>**Contraseña**: 1234567890

_Comando_: ```CREATE USER 'chronoteadmin'@'localhost' IDENTIFIED BY '1234567890';```

Después de crear el usuario con su contraseña debe darle privilegios de uso en la base de datos con ```GRANT ALL ON chronotebd_test.*  TO 'chronoteadmin'@'localhost';```

Finalmente hay que colocar las credenciales dentro del fichero ```config/database.yml``` donde debe quedar de esta forma:

```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: chronoteadmin # El usuario que se configuró
  password: 1234567890 # La contraseña (de preferencia no debe quedar visible)
  socket: /tmp/mysql.sock

development:
  <<: *default
  database: chronotebd_test

```

* Database initialization

Simplemente coloque el comando ```rails db:migrate``` dentro de la carpeta del proyecto para migrar el esquema de base datos a mysql/mariadb. Entrando con su usuario y contraseña, dentro de la base de datos se debería poder ver las tablas y sus atributos.

* Usage

Para probar la api simplemente inicie el servidor con ```rails s``` y puede probar peticiones como el registro de un usuario (usando unix): 

```
curl -i -H "Content-Type:application/json" -X POST http://localhost:3000/api/v1/usuarios -d '{"usuario": {"nombre": "Usuario", "correo": "ejemplo@email.com", "contrasena": "secretisimo"}}'
```

Puede realizar una consulta de todos los usuarios registrados en la base de datos entrando al navegador con la liga ```http://localhost:3000/api/v1/usuarios``` o consultarlo por id como por ejemplo al usuario con id 1 colocando ```http://localhost:3000/api/v1/usuarios/1```.