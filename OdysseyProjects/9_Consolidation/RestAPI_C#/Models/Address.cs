using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System;

namespace Rocket_Elevator_RESTApi.Models
{
    public class Address
    {
        public int id { get; set; }
        public string type_address { get; set; }
        public string status { get; set; }
        public string entite { get; set; }
        public string address { get; set; }       
        public string city { get; set; }
        public string postal_code { get; set; }
        public string country { get; set; }
        public string notes { get; set; }
        public string full_street_address { get; set; }
    
    }
}