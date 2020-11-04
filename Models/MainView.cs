using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Bookface.Models
{
    public class MainView
    {
        public Usuario Usuario { get; set; }
        public List<Publicacion> Publicaciones { get; set; }
        public List<Usuario> Amigos { get; set; }
    }
}
