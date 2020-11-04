using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace Bookface.Models
{
    public class Usuario
    {
        [Key]
        public int ID_USUARIO { get; set; }
        public string CORREO { get; set; }
        public string NOMBRE1 { get; set; }
        public string NOMBRE2 { get; set; }
        public string APELLIDO1 { get; set; }
        public string APELLIDO2 { get; set; }
        public DateTime FECHA_DE_NACIMIENT { get; set; }
        public string CONTRASENA { get; set; }
        public int CANT_MAX_AMIGOS { get; set; }
        public DateTime FECHA_CREACION { get; set; }
    }
}
