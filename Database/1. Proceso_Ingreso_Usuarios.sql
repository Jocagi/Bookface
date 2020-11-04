/*Ingreso Usuarios 
Crear un proceso para poder agregar N usuarios, con su información
respectiva, realizando las validaciones correspondientes, y tomando en
cuenta que si se encuentran usuarios con los mismos apellidos
automáticamente se relacionan y entran dentro de los 50 amigos que tienen
permitido asociar.
	? Proceso para carga de archivo automático.
	? SubProceso para procesar cada línea del archivo. */

create or alter TRIGGER ModificandoAmigo ON dbo.USUARIO for INSERT 
AS
--SET IDENTITY_INSERT dbo.AMIGO ON
INSERT INTO dbo.AMIGO
(
	ID_USUARIO,
	ID_AMIGO
)
SELECT i.ID_USUARIO, u.ID_USUARIO
from INSERTED i , dbo.USUARIO u
WHERE (Upper(trim(i.APELLIDO1)) = Upper(trim(u.APELLIDO1)) OR Upper(trim(i.APELLIDO2 ))= Upper(trim(u.APELLIDO2))) AND i.ID_USUARIO != u.ID_USUARIO
--SET IDENTITY_INSERT dbo.AMIGO OFF

--Procedimiento que ingresa los N usuarios + subproceso para para procesar cada linea del archivo 
CREATE or alter  PROCEDURE IngresandoUsuarios
AS
BEGIN
	BULK INSERT Bookface..USUARIO FROM 'C:\Users\karen\Desktop\bases.csv'
	WITH 
	(
	DATAFILETYPE = 'CHAR', 
	FIELDTERMINATOR=';', 
	ROWTERMINATOR='\n',
	FIRE_TRIGGERS
	)
END 


EXEC IngresandoUsuarios

