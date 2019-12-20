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
    	List<Deal__c> ListOf = new List<Deal__c>([
			SELECT StartDate__c, EndDate__c, Status__c
   			FROM Deal__c
		]);

    for(Deal__c deal:ListOf) {
	   for(Deal__c newDeal: Trigger.new) {
		CarRentServices.checkDealDatetime(deal,newDeal);
        		}
			}
		}
	}
}