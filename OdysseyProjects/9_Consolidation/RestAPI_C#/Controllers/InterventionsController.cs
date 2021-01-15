using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Rocket_Elevator_RESTApi.Models;
using Microsoft.AspNetCore.JsonPatch;

namespace Rocket_Elevator_RESTApi.Controllers
{
    [ApiController]
    public class InterventionsController : ControllerBase
    {
        private readonly InformationContext _context;

        public InterventionsController(InformationContext context)
        {
            _context = context;
        }

        [Route("api/Interventions/Pending")]
        // GET: api/Interventions/Pending
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Intervention>>> GetInterventions()
        {   
            // Create a list of interventions where the status is "Pending" and the start_date_intervention is null
            var listInterventions =    from inter in _context.interventions
                                        where inter.start_date_intervention == null &&
                                        inter.status == "Pending"
                                        select inter;

            // Return the list to the client in json format
            return await listInterventions.ToListAsync();
        }

        [Route("api/Interventions/Start/{id}")]
        [HttpPut("{id}")]
        public async Task<ActionResult<Intervention>> InterventionStarted(int id)
        {
            // Create a instance of Intervention getting the data of the database with the id give in the query
            var intervention = await _context.interventions.FindAsync(id);

            // Check if the intervention exists
            if (id != intervention.id)
            {
                return BadRequest();
            }
            
            // Change the attribut to datetime a the query and the status to "InProgress"
            intervention.start_date_intervention = DateTime.Now;
            intervention.status = "InProgress";
            
            // Push modifications to the database
            await _context.SaveChangesAsync();

            // Return the new object internvention with the modifications to the client
            return intervention;
        }

        [Route("api/Interventions/End/{id}")]
        [HttpPut("{id}")]

        public async Task<ActionResult<Intervention>> InterventionFinish(int id)
        {
            // Create a instance of Intervention getting the data of the database with the id give in the query
            var intervention = await _context.interventions.FindAsync(id);
            
            // Check if the intervention exists
            if (id != intervention.id)
            {
                return BadRequest();
            }

            // Change the end_date_intervention attribut to datetime a the query and the status to "Complete"
            intervention.end_date_intervention = DateTime.Now;
            intervention.status = "Complete";

            // Push modifications to the database
            await _context.SaveChangesAsync();
            
            // Return the new object internvention with the modifications to the client
            return intervention;
        }
    }
}
