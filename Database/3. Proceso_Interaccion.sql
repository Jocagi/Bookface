 /* 
 Interacción (15pts) 
 El proceso tendrá la capacidad de recibir una interacción para una publicación en específico. 
 Solicitando la información respectiva según las reglas descritas. 
	▪ Nivel de aislamiento 
 */

Create or Alter Procedure uspIngresarInteraccion
@ID_Publicacion integer,
@ID_Usuario integer,
@ID_Accion integer -- Se asume 1 para Like y 2 para Dislike
As
Begin

	Set transaction isolation level serializable;
	Begin transaction

	Declare @CantLikeGeneral integer;
	Declare @CantDislikeGeneral integer;

	Declare @CantLikeUsuario integer;
	Declare @CantDislikeUsuario integer;

	-- Contar likes y dislikes totales, tomando en cuenta solo los validos.
	-- Cuando una accion se deshace, se resta del total respectivo
	Select
	@CantLikeGeneral =
	COALESCE(SUM(case    when ID_TIPO_ACCION = 1 then 1
				when ID_TIPO_ACCION = 3 then -1
				else 0 end),0),
	@CantDislikeGeneral =
	COALESCE(SUM(case    when ID_TIPO_ACCION = 2 then 1
				when ID_TIPO_ACCION = 4 then -1
				else 0 end),0),
	@CantLikeUsuario =
	COALESCE(SUM(case    when ID_TIPO_ACCION = 1 AND ID_USUARIO = @ID_Usuario then 1
				when ID_TIPO_ACCION = 3 AND ID_USUARIO = @ID_Usuario then -1
				else 0 end),0),
	@CantDislikeUsuario =
	COALESCE(SUM(case    when ID_TIPO_ACCION = 2 AND ID_USUARIO = @ID_Usuario then 1
				when ID_TIPO_ACCION = 4 AND ID_USUARIO = @ID_Usuario then -1
				else 0 end),0)
	from BITACORA
	Where ID_PUBLICACION = @ID_Publicacion

	
	IF EXISTS (	Select P.ID_USUARIO, A.ID_AMIGO from PUBLICACION P
				Inner Join AMIGO A on P.ID_USUARIO = A.ID_USUARIO
				Where ID_PUBLICACION = @ID_Publicacion AND (A.ID_AMIGO = @ID_Usuario OR P.ID_USUARIO = @ID_Usuario) )
	Begin

		-- Remover Like
		If (@ID_Accion = 3)
			Begin
				If (@CantLikeUsuario > 0)
					Begin
						Insert Into BITACORA (ID_PUBLICACION, ID_USUARIO, ID_TIPO_ACCION, FECHA_HORA)
						Values (@ID_Publicacion, @ID_Usuario, 3, GETDATE());
						commit;
					End
				Else
					Begin
						Print('No existen likes para remover');
						rollback;
					End
			End
		-- Remover Dislike
		Else If (@ID_Accion = 4)
			Begin
				If (@CantDislikeUsuario > 0)
					Begin
						Insert Into BITACORA (ID_PUBLICACION, ID_USUARIO, ID_TIPO_ACCION, FECHA_HORA)
						Values (@ID_Publicacion, @ID_Usuario, 4, GETDATE());
						commit;
					End
				Else
					Begin
						Print('No existen dislikes para remover');
						rollback;
					End
			End
		-- Insertar Like o Dislike
		Else If (@ID_Accion = 1 OR @ID_Accion = 2)
			Begin
				If (@ID_Accion = 1 OR (@ID_Accion = 2 AND @CantLikeGeneral > @CantDislikeGeneral))
					Begin
						If (@CantLikeUsuario = 0 AND @CantDislikeUsuario = 0)
							Begin
									Insert Into BITACORA (ID_PUBLICACION, ID_USUARIO, ID_TIPO_ACCION, FECHA_HORA)
									Values (@ID_Publicacion, @ID_Usuario, @ID_Accion, GETDATE());
									commit;
							End
						Else
							Begin
								Print('El usuario ya ha interactuado con la publicacion');
								rollback;
							End
					End
				Else
					Begin
						Print('No existen suficientes likes para insertar un nuevo dislike');
						rollback;
					End
			End
		Else
			Begin
				Print('Interaccion no reconocida');
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
exec uspIngresarInteraccion 3, 23, 1