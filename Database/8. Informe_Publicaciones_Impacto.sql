/*Detalle de publicaciones que en algún momento impactaron en el incremento de la
cantidad máxima de amigos para un usuario.*/

CREATE OR ALTER PROCEDURE PublicacionesImpacto 
AS
BEGIN
DECLARE @MeGusta int, @NoMeGusta int
SET @MeGusta = 0; SET @NoMeGusta = 0;
SELECT U.nombre1 AS [Nombre], U.Apellido1 AS [Apellido], P.fecha_hora AS [Fecha y hora de publicacion],
		P.contenido AS [Contenido de publicación], D.id_dispositivo AS [Dispositivo],
		TP.tipo AS [Tipo de publicacion], P.ip AS [IP de creacion]

FROM bitacora B
	INNER JOIN Publicacion P on (P.id_publicacion = B.id_publicacion)
	INNER JOIN Tipo_accion A ON (A.id_tipo_accion = B.id_tipo_accion)
	INNER JOIN Usuario U ON (U.id_usuario = P.id_usuario)
	INNER JOIN Tipo_publicacion TP ON (TP.id_tipo_publicacion = P.id_tipo_publicacion)
	INNER JOIN Dispositivo D ON (D.id_dispositivo = P.id_dispositivo)

GROUP BY A.accion, U.nombre1, U.Apellido1, P.fecha_hora, P.contenido, D.id_dispositivo, TP.tipo, P.ip
HAVING COUNT(CASE WHEN A.id_tipo_accion = 1 THEN 1 END) - COUNT(CASE WHEN A.id_tipo_accion = 2 THEN 1 END) - COUNT(CASE WHEN A.id_tipo_accion = 3 THEN 1 END) + COUNT(CASE WHEN A.id_tipo_accion = 4 THEN 1 END) > 14 --tomando 1 como el id de la acción 'like'
END

EXEC PublicacionesImpacto

