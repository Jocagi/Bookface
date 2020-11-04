/*
Solamente puede existir un usuario por correo electrónico y máximo 2 con el mismo nombre (completo).
*/

Create or Alter trigger tiu_ValidarUsuario on USUARIO
Instead of insert, update
as

Set transaction isolation level serializable;
Begin transaction;

Declare @Id int
Declare @Correo nvarchar(50)
Declare @Nombre1 nvarchar(50)
Declare @Nombre2 nvarchar(50)
Declare @Apellido1 nvarchar(50)
Declare @Apellido2 nvarchar(50)
Declare @BirthDate date
Declare @Creacion datetime
Declare @Password nvarchar(50)
Declare @Amigos int

Declare @Cant_Users int

Select 
	@Id = ID_USUARIO,
	@Correo = CORREO,
	@Nombre1 = NOMBRE1,
	@Nombre2 = NOMBRE2,
	@Apellido1 = APELLIDO1,
	@Apellido2 = APELLIDO2,
	@BirthDate = FECHA_DE_NACIMIENT,
	@Creacion = FECHA_CREACION,
	@Password = CONTRASENA,
	@Amigos = CANT_MAX_AMIGOS
From inserted

-- Obtener usuarios con mismo nombre
Select @Cant_Users = Count(1) 
From USUARIO U
Where 
	U.NOMBRE1 = @Nombre1 AND
	(U.NOMBRE2 = @Nombre2 OR (U.NOMBRE2 IS NULL AND @Nombre2 IS NULL)) AND 
	U.APELLIDO1 = @Apellido1 AND
	(U.APELLIDO2 = @Apellido2 OR (U.APELLIDO2 IS NULL AND @Apellido2 IS NULL))

If (@Cant_Users < 2)
	Begin
		--Validar si es INSERT o un UPDATE
		--UPDATE
		If EXISTS(Select * from deleted) 
			Begin
				Update USUARIO
				Set CORREO = @Correo, NOMBRE1 = @Nombre1, NOMBRE2 = @Nombre2, APELLIDO1 = @Apellido1, APELLIDO2 = @Apellido2, 
				FECHA_DE_NACIMIENT = @BirthDate, CONTRASENA = @Password, CANT_MAX_AMIGOS = @Amigos
				Where ID_USUARIO = @Id;
				commit;
			End
		-- INSERT
		Else		
			Begin
				Insert into USUARIO
				(CORREO, NOMBRE1, NOMBRE2, APELLIDO1, APELLIDO2, FECHA_DE_NACIMIENT, CONTRASENA, CANT_MAX_AMIGOS, FECHA_CREACION)
				Values
				(@Correo, @Nombre1, @Nombre2, @Apellido1, @Apellido2, @BirthDate, @Password, 50, GetDate());
				commit;
			End
	End
Else
	Begin
		Print ('No se ha podido realizar la operacion. Maximo de usuarios con el mismo nombre alcanzado.');
		commit;
	End

	--Pruebas

	Select * from USUARIO

	Insert into USUARIO
				(CORREO, NOMBRE1, APELLIDO1, FECHA_DE_NACIMIENT, CONTRASENA, CANT_MAX_AMIGOS, FECHA_CREACION)
				Values
				('sdfdjfudfuun@gmail.com', 'Andrea', 'Camara', '2000-01-01', '123', 50, GetDate());

			