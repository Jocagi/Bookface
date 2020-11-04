using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Bookface.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Bookface.Controllers
{
    public class MainController : Controller
    {
        private BookfaceContext _db;

        public MainController(BookfaceContext context)
        {
            _db = context;
        }

        public IActionResult Index()
        {
            if (Request.Cookies["User"] != null)
            {
                MainView data = new MainView();
                var username = Request.Cookies["User"];

                //Informacion de usuario
                string queryUsuario = "SELECT * FROM USUARIO WHERE CORREO = {0}";
                var users = _db.Usuarios
                    .FromSqlRaw(queryUsuario, username);
                var userList = users.ToList();
                data.Usuario = userList[0];

                //Informacion de amigos
                string queryAmigos = "SELECT U2.ID_USUARIO, U2.CORREO, U2.NOMBRE1, U2.NOMBRE2, U2.APELLIDO1, U2.APELLIDO2, U2.FECHA_DE_NACIMIENT, U2.CONTRASENA, U2.CANT_MAX_AMIGOS, U2.FECHA_CREACION FROM USUARIO U1 INNER JOIN AMIGO A ON A.ID_USUARIO = U1.ID_USUARIO Inner Join USUARIO U2 ON A.ID_AMIGO = U2.ID_USUARIO WHERE U1.ID_USUARIO = {0}";
                var amigos = _db.Usuarios
                    .FromSqlRaw(queryAmigos, data.Usuario.ID_USUARIO);
                var friendList = amigos.ToList();
                data.Amigos = friendList;

                //Informacion de publicaciones
                string queryPublicacion = "SELECT \n"
                                          + "P.ID_PUBLICACION, ID_DISPOSITIVO, (U.NOMBRE1 + ' ' + ISNULL(NOMBRE2, '') + ' ' + U.APELLIDO1 + ' ' + ISNULL(APELLIDO2, '')) AS NOMBRE_USUARIO,\n"
                                          + "P.FECHA_HORA, P.CONTENIDO, ISNULL(_LIKE, 0) AS _LIKE, ISNULL(_DISLIKE,0) AS _DISLIKE\n"
                                          + "FROM PUBLICACION P\n"
                                          + "Left Join(\n"
                                          + "\tSelect\n"
                                          + "\t\tID_PUBLICACION,\n"
                                          + "\t\tCOALESCE(SUM(case    when ID_TIPO_ACCION = 1 then 1\n"
                                          + "\t\t\t\t\twhen ID_TIPO_ACCION = 3 then -1\n"
                                          + "\t\t\t\t\telse 0 end),0) as _LIKE,\n"
                                          + "\t\tCOALESCE(SUM(case    when ID_TIPO_ACCION = 2 then 1\n"
                                          + "\t\t\t\t\twhen ID_TIPO_ACCION = 4 then -1\n"
                                          + "\t\t\t\t\telse 0 end),0) as _DISLIKE\n"
                                          + "\t\tfrom BITACORA\n"
                                          + "\t\tGroup by ID_PUBLICACION\n"
                                          + ")B ON B.ID_PUBLICACION = P.ID_PUBLICACION\n"
                                          + "Inner Join USUARIO U ON U.ID_USUARIO = P.ID_USUARIO\n"
                                          + "Where  \n"
                                          + "P.ID_USUARIO IN(Select ID_AMIGO FROM AMIGO WHERE ID_USUARIO = 86) OR\n"
                                          + "P.ID_USUARIO IN (86)"
                                          +"ORDER BY P.FECHA_HORA DESC";
                var posts = _db.Publicaciones
                    .FromSqlRaw(queryPublicacion, data.Usuario.ID_USUARIO);
                var postList = posts.ToList();
                data.Publicaciones = postList;

                return View(data);
            }
            else
            {
                return Redirect("~/Login/Index");
            }
        }

        [HttpPost]
        public IActionResult Index(string content)
        {
            if (Request.Cookies["User"] != null && content != null)
            {
                var username = Request.Cookies["User"];

                string queryUsuario = "SELECT * FROM USUARIO WHERE CORREO = {0}";
                var users = _db.Usuarios
                    .FromSqlRaw(queryUsuario, username);
                var userList = users.ToList();
                
                int userid = userList[0].ID_USUARIO;

                //Insertar en publicacion
                string query = "Insert into \r\nPUBLICACION(ID_DISPOSITIVO, ID_TIPO_PUBLICACION, ID_USUARIO, FECHA_HORA, CONTENIDO, IP)\r\nValues\r\n(1,1,{0},GETDATE(),{1},'192.168.0.1')\r\n";
                _db.Database.ExecuteSqlCommand(query, userid, content);
            }

            return Redirect("~/Main/Index");
        }

        [HttpPost]
        public IActionResult Interaccion(int id, int type)
        {
            if (Request.Cookies["User"] != null)
            {
                var username = Request.Cookies["User"];

                //Obtener el id del usuario
                string queryUsuario = "SELECT * FROM USUARIO WHERE CORREO = {0}";
                var users = _db.Usuarios
                    .FromSqlRaw(queryUsuario, username);
                var userList = users.ToList();
                int userid = userList[0].ID_USUARIO;


                //Validar en publiciones la accion
                string queryPub = "\tSelect\n"
                                  + "\tCOALESCE(SUM(case    when ID_TIPO_ACCION = 1 AND ID_USUARIO = {0} then 1\n"
                                  + "\t\twhen ID_TIPO_ACCION = 3 AND ID_USUARIO = {0} then -1\n"
                                  + "\t\telse 0 end),0) As _LIKES,\n"
                                  + "\tCOALESCE(SUM(case    when ID_TIPO_ACCION = 2 AND ID_USUARIO = {0} then 1\n"
                                  + "\t\twhen ID_TIPO_ACCION = 4 AND ID_USUARIO = {0} then -1\n"
                                  + "\t\telse 0 end),0) As _DISLIKES\n"
                                  + "\tfrom BITACORA\n"
                                  + "\tWhere ID_PUBLICACION = {1}";
                var values = _db.Interacciones
                    .FromSqlRaw(queryPub, userid, id);
                int likesUser = values.ToList()[0]._LIKES;
                int dislikesUser = values.ToList()[0]._DISLIKES;

                if (type == 1 && likesUser > 0)
                {
                    type = 3;
                }
                if (type == 2 && dislikesUser > 0)
                {
                    type = 4;
                }

                //Insertar en bitacora
                string query = "exec uspIngresarInteraccion {0}, {1}, {2}";
                _db.Database.ExecuteSqlCommand(query, id, userid, type);
            }

            return Redirect("~/Main/Index");
        }

    }
}
