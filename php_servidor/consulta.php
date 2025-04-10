<?php

include 'conexion.php';

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$sql = "
WITH LatestNote AS (
    SELECT
        n.idTema,
        n.descripcion AS descripcion_ultima_nota,
        n.fechaCreacion,
        ROW_NUMBER() OVER(PARTITION BY n.idTema ORDER BY n.fechaCreacion DESC) as rn
    FROM notas n
)
SELECT
    a.nombre AS titulo_actividad,
    a.descripcion AS descripcion_actividad,
    ln.descripcion_ultima_nota,  -- Descripción de la última nota del tema
    -- Comprobamos si existe alguna entrada en horaactividad para esta actividad
    (EXISTS (SELECT 1 FROM horaactividad h WHERE h.idActividad = a.idActividad)) AS tiene_horario,
    t.nombre AS nombre_tema,
    t.posee_calendario AS tema_posee_calendario
FROM
    actividades a
JOIN
    temas t ON a.idTema = t.idTema
LEFT JOIN -- Usamos LEFT JOIN por si un tema no tiene notas aún
    LatestNote ln ON t.idTema = ln.idTema AND ln.rn = 1 -- Nos quedamos solo con la más reciente (rn=1)
ORDER BY
    t.nombre, a.nombre; -- Opcional: Ordenar resultados
";

$result = $conn->query($sql);

if ($result === FALSE) {
    echo "Error en la consulta: " . $conn->error;
} elseif ($result->num_rows > 0) {
    echo "<h2>Resultados de la Consulta:</h2>";
    echo "<table border='1'>";
    echo "<tr><th>Título Actividad</th><th>Descripción Actividad</th><th>Última Nota (del Tema)</th><th>Tiene Horario?</th><th>Nombre Tema</th><th>Tema con Calendario?</th></tr>";

    while($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($row["titulo_actividad"]) . "</td>";
        echo "<td>" . htmlspecialchars($row["descripcion_actividad"] ?? 'N/A') . "</td>"; // Usar ?? para manejar NULLs
        echo "<td>" . htmlspecialchars($row["descripcion_ultima_nota"] ?? 'N/A') . "</td>";
        echo "<td>" . ($row["tiene_horario"] ? 'Sí' : 'No') . "</td>";
        echo "<td>" . htmlspecialchars($row["nombre_tema"]) . "</td>";
        echo "<td>" . ($row["tema_posee_calendario"] ? 'Sí' : 'No') . "</td>";
        echo "</tr>";
    }
    echo "</table>";
} else {
    echo "No se encontraron actividades que cumplan los criterios.";
}

$conn->close();

?>