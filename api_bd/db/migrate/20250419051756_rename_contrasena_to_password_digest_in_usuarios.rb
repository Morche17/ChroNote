class RenameContrasenaToPasswordDigestInUsuarios < ActiveRecord::Migration[8.0]
  def change
    rename_column :usuarios, :contrasena, :password_digest
  end
end
