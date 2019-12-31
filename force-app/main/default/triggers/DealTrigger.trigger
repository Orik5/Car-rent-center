trigger DealTrigger on Deal__c (before insert,before update) {
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
			for(Deal__c deal:Trigger.new ) {
				CarRentServices carRentServices = new CarRentServices();
				carRentServices.filterFinished(deal);
            }
    	    // List<Deal__c> deals = new List<Deal__c>([
			// 	SELECT StartDate__c, EndDate__c, Status__c
   			// 	FROM Deal__c
			// ]);

    		for(Deal__c deal : deals) {
	  			for(Deal__c newDeal: Trigger.new) {
					CarRentServices.checkDealDatetime(deal, newDeal);
        		}
			}
		}
	
		if(trigger.isInsert /*|| trigger.isUpdate*/){
			List<Deal__c> deals = new List<Deal__c>([
			SELECT Name, Car__c, Sales_Manager__c
   			FROM Deal__c
		]);
	    for(Deal__c deal : deals){
			for (Deal__c newDeal:Trigger.new){
				CarRentServices.checkDublicateDeal(deal, newDeal);
	    		}
     		}
		}
	}
}