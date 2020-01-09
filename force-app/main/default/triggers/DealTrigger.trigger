trigger DealTrigger on Deal__c (before insert, before update) {
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
	    CarRentServices carRentServices = new CarRentServices();
	    carRentServices.filterFinished(Trigger.new);             			
    	}		
	if(trigger.isInsert) {
	   CarRentServices.checkDublicateDeal(Trigger.new);
	   CarRentServices.checkDealDatetime(Trigger.new);	
	}
    }
}
