/*Número de publicaciones al mes, con el 100% de su capacidad de comentarios llena (INFORME)*/

CREATE OR ALTER PROCEDURE pResPublicaciones AS
	begin
	SELECT k.mes, k.anio,count(1) as cantPublicacion
	FROM
	(
	select MONTH(P.FECHA_HORA) mes,YEAR(P.FECHA_HORA) anio, COUNT(1) as cantidad
	from PUBLICACION P
	inner join COMENTARIO C on P.ID_PUBLICACION = C.ID_COMENTARIO
	GROUP BY MONTH(P.FECHA_HORA),YEAR(P.FECHA_HORA),C.ID_PUBLICACION_REF
	) AS K
	where cantidad > 2
	GROUP BY k.mes, k.anio
END  

EXEC pResPublicaciones