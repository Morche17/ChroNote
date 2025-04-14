<?php
session_start();
include("conexion.php");
$correo = $_POST['email'];
$password = $_POST['contraseña'];
$con = conectar();

$query = "SELECT id, email, contraseña";
$result = mysqli_query($con, $query);
$coso = "El usuario no existe";

while ($row = mysqli_fetch_array($result)){
    $id= $row['id']; 
    $emailv = $row['email'];
    $passv = $row['password'];
    $rol = $row['rol'];
    if ($emailv == $correo){
        if ($passv == $password){
            $_SESSION['user_id'] = $id;
            $_SESSION['user_rol'] = $rol;
            header ("Location: user_menu");
        }
        else{
            $coso = "Tu contraseña no es correcta";
        }
    }
}
?>