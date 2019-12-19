trigger DealTrigger on Deal__c (before insert,before update ,after insert) {
    if(trigger.isBefore){
    	if(trigger.isUpdate){
			for(Deal__c deal:Trigger.new ){
            	if(deal.Status__c != 'Lost'){
                	deal.EndDate__c = Datetime.now();
                }
            }
	   }
    }
	if(trigger.isBefore){
        if (trigger.isInsert) {
        	Set<Datetime> startDate = new Set<Datetime>();
            Set<Datetime> endDate = new Set<Datetime>();
			Set<String> statuses = new Set<String>();
			String wonStatus ='Won';
			String openStatus ='Open';
            
	for(Deal__c deal : trigger.new){
		startDate.add(deal.StartDate__c);
        endDate.add(deal.EndDate__c);
		statuses.add(deal.Status__c);
	  }
	if(startDate.size() > 0 && endDate.size()>0){
		List<Deal__c> lstDeals = [select StartDate__c ,EndDate__c from Deal__c 
        where StartDate__c in :startDate and EndDate__c in :endDate];		
		Map<Datetime ,Deal__c> dealStartDate = new Map<Datetime,Deal__c>();
	for(Deal__c deal: lstDeals){
		dealStartDate.put(deal.StartDate__c,deal);
		}
 	Map<Datetime ,Deal__c> dealEndDate = new Map<Datetime,Deal__c>();
	for(Deal__c deal: lstDeals){
		dealStartDate.put(deal.EndDate__c,deal);
		}
	Map<String ,Deal__c> dealWonStatus = new Map<String,Deal__c>();
	for(Deal__c deal: lstDeals){
		dealWonStatus.put(deal.Status__c,deal);
		}
	Map<String ,Deal__c> dealOpenStatus = new Map<String,Deal__c>();
	for(Deal__c deal: lstDeals){
		dealOpenStatus.put(deal.Status__c,deal);
		}	
	for(Deal__c deal1 : trigger.new){
		if(dealStartDate.containsKey(deal1.StartDate__c)&& dealEndDate.containsKey(deal1.EndDate__c)
		&& dealWonStatus.containsKey(wonStatus)||dealOpenStatus.containsKey(openStatus)) {
     	deal1.StartDate__c.addError('Start date already Exist ');
        deal1.EndDate__c.addError('End date already Exist ');

			    	}
		    	}
        	}
  		}                                       
	}
}