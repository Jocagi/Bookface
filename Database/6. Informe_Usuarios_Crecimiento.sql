
/*Número de usuarios nuevos por día y porcentaje de crecimiento*/

CREATE OR ALTER PROCEDURE Reporte 
AS
BEGIN
--Tabla temporal creada
CREATE TABLE
#ReporteDeCrecimiento (ID INT IDENTITY(1,1), fecha_creacion DATE, cantidad_usuarios INT, porcentaje INT);

--Insertando fechas y cantidades (con 0% en todo de crecimiento)
INSERT INTO #ReporteDeCrecimiento
	(fecha_creacion, cantidad_usuarios, porcentaje)
SELECT U.fecha_creacion, 0, 0
FROM Bitacora B
		INNER JOIN USUARIO U ON (U.id_usuario = B.id_usuario)
GROUP BY U.fecha_creacion
ORDER BY U.fecha_creacion ASC

--Cursor para calcular el porcentaje en la tabla actual
DECLARE @fecha date, @cantUsr int, @totalUsrs int
SET @totalUsrs = 0;

DECLARE C_CrecimientoUsr CURSOR GLOBAL FOR
SELECT fecha_creacion, cantidad_usuarios
FROM #ReporteDeCrecimiento

OPEN C_CrecimientoUsr
FETCH NEXT FROM C_CrecimientoUsr INTO @fecha, @cantUsr 
WHILE (@@FETCH_STATUS = 0)
BEGIN

	UPDATE #ReporteDeCrecimiento
	SET cantidad_usuarios = (	
								SELECT COUNT(Us.id_usuario) FROM USUARIO Us WHERE @fecha = fecha_creacion
								GROUP BY fecha_creacion
								 
							)
	WHERE @fecha = fecha_creacion 

	IF @totalUsrs = 0
	BEGIN

			UPDATE #ReporteDeCrecimiento
			SET porcentaje = 100
			WHERE @fecha = fecha_creacion 

			SET @totalUsrs = ( SELECT cantidad_usuarios FROM #ReporteDeCrecimiento WHERE @fecha = fecha_creacion )
	END
	ELSE
	BEGIN	
			SET @cantUsr = ( SELECT cantidad_usuarios FROM #ReporteDeCrecimiento WHERE @fecha = fecha_creacion )

			UPDATE #ReporteDeCrecimiento
			SET porcentaje = (@cantUsr*100)/@TotalUsrs
			WHERE @fecha = fecha_creacion 

			SET @totalUsrs = @totalUsrs + @cantUsr
	END
	FETCH NEXT FROM C_CrecimientoUsr into @fecha,  @cantUsr
END
CLOSE C_CrecimientoUsr
DEALLOCATE C_CrecimientoUsr

SELECT *
FROM #ReporteDeCrecimiento

--Elimina tabla temporal
DROP TABLE #ReporteDeCrecimiento
END

exec Reporte