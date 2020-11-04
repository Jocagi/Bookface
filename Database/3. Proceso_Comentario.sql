
Create or Alter Procedure uspIngresarComentario
@ID_Publicacion integer,
@ID_Usuario integer,
@ID_Dispositivo integer,
@ID_Tipo integer,
@Contenido nvarchar(50),
@IP_Address nvarchar(50)
As
Begin

	Set transaction isolation level serializable;
	Begin transaction

	Declare @ComentPublicacion integer;
	Declare @ID_Comentario integer;

	IF EXISTS (	Select P.ID_USUARIO, A.ID_AMIGO from PUBLICACION P
				Inner Join AMIGO A on P.ID_USUARIO = A.ID_USUARIO
				Where ID_PUBLICACION = @ID_Publicacion AND (A.ID_AMIGO = @ID_Usuario OR P.ID_USUARIO = @ID_Usuario) )
	Begin


		-- Contar cantidad total de comentarios para una publicacion dada
		Select @ComentPublicacion = COUNT(1)
		from COMENTARIO
		Where	ID_PUBLICACION_REF = @ID_Publicacion 
				AND ACTIVO = 1

		-- Ingresar contenido del comentario
		Insert Into PUBLICACION (ID_DISPOSITIVO, ID_TIPO_PUBLICACION, ID_USUARIO, FECHA_HORA, CONTENIDO, IP)
		Values (@ID_Dispositivo, @ID_Tipo, @ID_Usuario, GETDATE(), @Contenido, @IP_Address);

		-- Valor del ID comentaario
		Set @ID_Comentario = SCOPE_IDENTITY();

		-- Validar activo/inactivo
		If (@ComentPublicacion < 3)
			Begin
				Insert Into COMENTARIO (ID_COMENTARIO, ID_PUBLICACION_REF, ACTIVO)
				Values (@ID_Comentario, @ID_Publicacion, 1)
			End
		Else
			Begin
				Insert Into COMENTARIO (ID_COMENTARIO, ID_PUBLICACION_REF, ACTIVO)
				Values (@ID_Comentario, @ID_Publicacion, 0)
			End
	
		If @@ERROR = 0
			Begin
				Print('Comentario ingresado con exito');
				commit;
			End
		Else
			Begin
				Print('Error al ingresar comentario');
				rollback;
			End
		End
	Else
		Begin
			Print('El usuario no se encuentra en la lista de amigos');
			rollback;
		End
End

--Pruebas

Select * from PUBLICACION
Select * from COMENTARIO
exec uspIngresarComentario 162, 46, 1, 1, 'Hola Mundo5!', '192.168.01.01'

