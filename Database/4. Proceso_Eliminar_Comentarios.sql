/*ELIMINAR COMENTARIOS*/

/*El proceso podrá eliminar un comentario específico de una publicación,
deberá validar si existen comentarios en cola ( y que no están activos) para
que ocupen el lugar que deja el comentario eliminado. */

CREATE OR ALTER procedure COMENTARIOEliminar
	@IdComentario integer  as
begin
	
	declare @contador int
	select @contador = COUNT(1)
	from COMENTARIO
	where ID_COMENTARIO = @IdComentario

	if(@contador != 0)
	BEGIN
		declare @activo bit
		declare @publi int
		select @activo = ACTIVO, @publi = ID_PUBLICACION_REF
		from COMENTARIO
		where ID_COMENTARIO = @IdComentario

		
		/*ELIMINAR DE COMENTARIO*/
		DELETE FROM COMENTARIO
		WHERE ID_COMENTARIO = @IdComentario
		/*ELIMINAR DE PUBLICACION*/
		DELETE FROM PUBLICACION
		WHERE ID_PUBLICACION = @IdComentario
		

		PRINT 'El comentario fue eliminado'

		if(@activo=1)
		begin
			declare @comentProx int

			select TOP 1 @comentProx = C.ID_COMENTARIO
			from PUBLICACION P
				inner join COMENTARIO C on (P.ID_PUBLICACION = C.ID_COMENTARIO)
			where C.ID_PUBLICACION_REF = @publi  AND C.ACTIVO = 0
			order by P.FECHA_HORA

		UPDATE COMENTARIO
		SET ACTIVO = 1
		WHERE ID_COMENTARIO = @comentProx;
		
		end
	END
	ELSE
	BEGIN
		PRINT 'El comentario no existe'
	END
end

