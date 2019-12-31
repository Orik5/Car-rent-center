trigger DealTrigger on Deal__c (before insert, before update) {
    if(trigger.isBefore) {
        if(trigger.isUpdate) {			
			CarRentServices carRentServices = new CarRentServices();
			carRentServices.filterFinished(Trigger.new[0]);             			
    	}
		
		if(trigger.isInsert) {
			CarRentServices.checkDublicateDeal(Trigger.new[0]); 
			CarRentServices.checkDealDatetime(Trigger.new[0]);	
		}
	}
}