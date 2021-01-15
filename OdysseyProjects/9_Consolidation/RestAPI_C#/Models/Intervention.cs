using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System;

namespace Rocket_Elevator_RESTApi.Models
{
    public class Intervention 
    {
        public int id { get; set; }
        public int author_id { get; set; }
        public int customer_id { get; set; }
        public int building_id { get; set; }
        public int? battery_id { get; set; }       // ? field can be null
        public int? column_id { get; set; }
        public int? elevator_id { get; set; }
        public int? employee_id { get; set; }
        public DateTime? start_date_intervention { get; set; }
        public DateTime? end_date_intervention { get; set; }
        public string result { get; set; }
        public string report { get; set; }
        public string status { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    
    }
}
