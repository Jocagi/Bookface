using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Bookface.Models
{
    public class Publicacion
    {
        [Key]
        public int ID_PUBLICACION { get; set; }
        public int ID_DISPOSITIVO { get; set; }
        public string NOMBRE_USUARIO { get; set; }
        public DateTime FECHA_HORA { get; set; }
        public string CONTENIDO { get; set; }
        public int _LIKE { get; set; }
        public int _DISLIKE { get; set; }
    }
}
