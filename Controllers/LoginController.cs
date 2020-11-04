using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Bookface.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Bookface.Controllers
{
    public class LoginController : Controller
    {
        private BookfaceContext _db;

        public LoginController(BookfaceContext context)
        {
            _db = context;
        }

        public IActionResult Index()
        {
            return View();
        }
        public IActionResult IndexError()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Index(string username, string password)
        {
            string query = "SELECT * FROM USUARIO WHERE CORREO = {0} AND CONTRASENA = {1}";
            var users = _db.Usuarios
                .FromSqlRaw(query, username, password);

            var userList = users.ToList();

            if (userList.Count > 0)
            {
                Response.Cookies.Append("User", username);
                return Redirect("~/Main/Index");
            }
            else
            {
                return Redirect("~/Login/IndexError");
            }
        }

        [HttpPost]
        public IActionResult IndexError(string username, string password)
        {
            return Index(username, password);
        }
    }
}
