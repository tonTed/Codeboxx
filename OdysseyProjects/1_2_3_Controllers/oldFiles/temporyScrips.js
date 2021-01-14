_createElevators() { 								//[Comment]
	for(let i = 0; i < this.qtyElevators; i++){
		let elevator = {["elevator" + i] : new Elevator(i)};
		this.listElevators.push(elevator);
	};
};