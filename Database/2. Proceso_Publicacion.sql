--Publicación (15 pts)
--Generación aleatoria de N publicaciones para M usuarios
--▪ Nivel de aislamiento

CREATE OR ALTER	 PROCEDURE  dbo.uspGenerarPublicaciones 
@cantPub integer,
@cantU integer
AS  --Transaction 

	set transaction isolation level read uncommitted;
	--BEGIN TRANSACTION
DECLARE @numU int--cantidad total de usuarios existentes
DECLARE @cont int = 0;
DECLARE @idusr int 
DECLARE @rndDispo int 
DECLARE @rndtipo int 
DECLARE @rndip nvarchar(15)
DECLARE @minId int
DECLARE @maxId int
DECLARE @Fecha datetime 
BEGIN
BEGIN TRANSACTION t 

	SELECT @numU = (SELECT count(1) FROM dbo.USUARIO u)
	SELECT @minId = (SELECT MIN(u.ID_USUARIO) FROM dbo.USUARIO u)
	SELECT @maxId = (SELECT MAX(u.ID_USUARIO) FROM dbo.USUARIO u)


	IF(@cantU > @numU)
	BEGIN
		ROLLBACK 
		PRINT 'No hay esa cantidad de usuarios'
	END 
	ELSE

		WHILE @cont < @cantPub
		BEGIN 
			SET @idusr = floor(RAND()*(@maxId - @minId)+ @minId); --random de asignacion de usuario
			SET @rndDispo = floor(RAND()*((15+1)-1)+1) --random para ingreso de dispositivo 
			SET @rndtipo = floor(RAND()*((3+1)-1)+1) --random para insertar el tipo de publicacion
			SET @Fecha = convert(datetime,'01-01-1980',0) + (365 * 41 * RAND() - 365) --cambiar para 2020
			SET @rndip = cast(floor(RAND()*((253+1)-1)+1) AS varchar(3))+'.'+cast(floor(RAND()*((253+1)-1)+1)AS varchar(3))+'.'
			+cast(floor(RAND()*((253+1)-1)+1)AS varchar(3))+'.'+cast(floor(RAND()*((253+1)-1)+1)AS varchar(3))
			INSERT INTO dbo.PUBLICACION
			(
				--ID_PUBLICACION - column value is auto-generated
				ID_DISPOSITIVO,
				ID_TIPO_PUBLICACION,
				ID_USUARIO,
				FECHA_HORA,
				CONTENIDO,
				IP
			)
				SELECT @rndDispo,@rndtipo,@idusr,@Fecha,'publicacion aleatoria No.'+cast(@cont as varchar(5)),@rndip

			SET @cont = @cont + 1;
			
		END 
		COMMIT TRANSACTION t 
END 
 
EXEC uspGenerarPublicaciones 40,5