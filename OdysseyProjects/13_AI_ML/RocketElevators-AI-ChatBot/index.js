
'use strict';
const functions = require('firebase-functions');
const {WebhookClient} = require('dialogflow-fulfillment');
const {Card, Suggestion} = require('dialogflow-fulfillment');
const axios = require('axios');
process.env.DEBUG = 'dialogflow:debug'; // enables lib debugging statements
exports.dialogflowFirebaseFulfillment = functions.https.onRequest((request, response) => {
  const agent = new WebhookClient({ request, response });
  console.log('Dialogflow Request headers: ' + JSON.stringify(request.headers));
  console.log('Dialogflow Request body: ' + JSON.stringify(request.body));

  function welcome(agent) {
    agent.add(`Welcome to my agent!`);
  }

  function fallback(agent) {
    agent.add(`I didn't understand`);
    agent.add(`I'm sorry, can you try again?`);
  }

  function getwelcome(agent){
    console.log('##### Inside get Welcome #####');
    return axios.get(`https://tontedrocketelevatorrestapi.azurewebsites.net/api/welcomes`)
    .then((result) => {
        agent.add(result.data);
    });
  }
  function getelevatorstatus(agent){
    const id = agent.parameters.integerperso;
    console.log('##### Inside getelevatorstatus #####');
    return axios.get(`https://tontedrocketelevatorrestapi.azurewebsites.net/api/elevators/${id}`)
    .then((result) => {
      	console.log(result.data);
        agent.add(result.data.status);
    });

  }
  function patchelevator(agent){
    const id = agent.parameters.id;
    const key = agent.parameters.key;
    const value = agent.parameters.value;
    console.log('##### Inside patch #####');
    return axios.patch(`https://tontedrocketelevatorrestapi.azurewebsites.net/api/elevators/${id}`, [{"op" : "replace", "path" : `${key}`, "value": `${value}`}])
    .then((result) => {
      	console.log(result.data);
      	agent.add(`Elevator ${result.data.id} ${key} changed to ${value}`);
    });
  }

  let intentMap = new Map();
  intentMap.set('Default Welcome Intent', welcome);
  intentMap.set('Default Fallback Intent', fallback);
  intentMap.set('getwelcomes', getwelcome);
  intentMap.set('getelevatorstatus', getelevatorstatus);
  intentMap.set('patchelevator', patchelevator);

  agent.handleRequest(intentMap);
});