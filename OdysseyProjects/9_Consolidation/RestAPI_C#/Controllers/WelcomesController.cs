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
    public class WelcomesController : ControllerBase
    {
        private readonly InformationContext _context;
        public WelcomesController(InformationContext context)
        {
            _context = context;
        }

        [Route("api/Welcomes")]
        [HttpGet]
        public string GetWelcomes(){

            // List<Elevator> elevators_list = _context.elevators.ToList();
            // int elevators_amount = elevators_list.Count();

            int elevators_amount = _context.elevators.ToList().Count();
            int batteries_amount = _context.batteries.ToList().Count();
            int quotes_amount = _context.quotes.ToList().Count();
            int leads_amount = _context.leads.ToList().Count();

            var list_elevtors_not_online =    from elevator in _context.elevators
                                        where elevator.status.ToLower() != "online"
                                        select elevator;

            int elevtors_not_online_amount = list_elevtors_not_online.Count();


            // Creer Model Customers = !!!Fait!!!
            int customers_amount = _context.customers.ToList().Count();

            // Cree Model Address = !!!Fait!!!
            IEnumerable<Address> addresses_building = from address in _context.addresses where address.type_address == "Building" select address;
            
            int buildings_count = addresses_building.Select(x => x.address).Distinct().Count();
            Console.WriteLine("buildings_count");
            Console.WriteLine(buildings_count);
            //Buildings count !!!FAIT!! Peut etre simplifie en utilisant simplement la table building

            int cities_distinct_count = addresses_building.Select(x => x.city).Distinct().Count();
            Console.WriteLine("cities_distinct_count");
            Console.WriteLine(cities_distinct_count);
            // listes des villes des batteries (buildings) avec suppression des doublons, recuperer la quantité !!!FAIT!!!
            //Notes A EFFACER:Dans address: 25 cities, 15 from buildings, 10 distinct

            

            // Creer link dans InformationContext entre buildings et addresses! !!!PAS FAIT!!!

            //Return Json { infos liste ou hash?} !!!return string comme discuté!!!
            string response = "Greetings!\nThere are currently " + elevators_amount + " elevators deployed in the " + buildings_count + " buildings of your " + customers_amount + " customers.\nCurrently, " + elevtors_not_online_amount + " elevators are not in Running Status and are being serviced.\n" + batteries_amount + " Batteries are deployed across " + cities_distinct_count + " cities.\nOn another note you currently have " + quotes_amount + " quotes awaiting processing.\nYou also have " + leads_amount + " leads in your contact requests.";
            
            return response;
        }
    }
}