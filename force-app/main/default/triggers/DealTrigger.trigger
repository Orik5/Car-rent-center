trigger DealTrigger on Deal__c (before insert,before update ,after insert) {
    if(trigger.isBefore){
    	if(trigger.isUpdate){
			List<Deal__c> deals = new List<Deal__c>();
			for(Deal__c deal:Trigger.new ){
				CarRentServices.changeDatetimeToNow(deal);
            }
	   }
    }

	if(trigger.isBefore){
		if(trigger.isUpdate){
    	List<Deal__c> deals = new List<Deal__c>([
			SELECT StartDate__c, EndDate__c, Status__c
   			FROM Deal__c
		]);

    for(Deal__c deal:deals) {
	   for(Deal__c newDeal: Trigger.new) {
		CarRentServices.checkDealDatetime(deal,newDeal);
        		}
			}
		}
	}
    if(trigger.isBefore){
		if(trigger.isInsert || trigger.isUpdate){
			List<Deal__c> deals = new List<Deal__c>([
			SELECT Name, Car__c, Sales_Manager__c
   			FROM Deal__c
		]);
	    for(Deal__c deal: deals){
			for (Deal__c newDeal:Trigger.new){
				CarRentServices.checkDublicateDeal(deal,newDeal);
	    		}
     		}
		}
	}
}