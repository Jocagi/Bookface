using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Bookface.Models
{
    public class UserInteraction
    {
        [Key]
        public int _LIKES { get; set; }
        public int _DISLIKES { get; set; }
    }
}
