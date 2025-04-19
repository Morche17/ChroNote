# app/views/api/v1/usuarios/index.json.jbuilder
# json.array! @usuarios do |usuario|
#   json.id usuario.id
#   json.nombre usuario.nombre
#   json.correo usuario.correo
# end

json.array! @usuarios, partial: "api/v1/usuarios/usuario", as: :usuario

