# app/views/api/v1/usuarios/show.json.jbuilder
json.data do
  json.usuario do
    json.partial! "api/v1/usuarios/usuario", usuario: @usuario
  end
end

# json.data do
#   json.usuario do
#     json.id @usuario.id
#     json.nombre @usuario.nombre
#     json.correo @usuario.correo
#   end
# end

# json.id @usuario.id
